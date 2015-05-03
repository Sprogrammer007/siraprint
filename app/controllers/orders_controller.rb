class OrdersController < ApplicationController
  
  before_filter :authenticate_approved!

  def create
    @errors = validate_order(params[:order][:details])
    @order = current_active.open_order || current_active.new_order(request.remote_ip)
    if @order && !@errors.any?    
      op = @order.create_new_ordered_product(params[:order], session[:current_rate])
      if op.save
        detail = op.create_details(params[:order][:product_type], params[:order][:details])
        if detail.save
          op.update(:product_detail_id => detail.id)
        end
      end
      @order.update_price
      @op = op
      Rails.logger.warn "#{op.details.side}"
      @side = (op.details.side || 1)
    end
    session[:current_rate] = nil
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def show
    if current_active.open_order && current_active.open_order.ordered_products.any?
      @order = current_active.open_order
      @order.update_price
    end
  end

  def delivery_info
    @order = current_active.open_order
  end

  def update_item
    item = OrderedProduct.find(params[:id])
    new_price = (item.unit_price * params[:quantity].to_i) 
    item.update(:quantity => params[:quantity], price: new_price)
    render :js => "window.location = '#{cart_path()}'"
  end

  def cancel
    order = Order.find(params[:id])
    if order.open?
      order.update(:status => "canceled")
    else
      flash[:notice] = "You cannot cancel this order."
    end
    redirect_to :back
  end

  def select_delivery
    @order = Order.find(params[:id])
    if params[:method] == "Pickup"
      @order.update!(delivery_address: DeliveryAddress.html_pickup_address, delivery_method: params[:method])
    else
      da = DeliveryAddress.find(params[:delivery_address_id])
      @order.update!(delivery_address: da.html_address, delivery_method: params[:method])
    end
    redirect_to check_out_order_path(@order)
  end

  def check_out
    @order = current_active.open_order
    @order.update_price
    @final = true
    render 'delivery_info'
  end

  def pay
    @order = current_active.open_order
    @order.final = true
    if @order.update(safe_order_cc)
      if @order.purchase
        OrderMailer.notify_order_placed(current_active, @order).deliver_now
        OrderMailer.thank_you_for_order(current_active, @order).deliver_now
        render 'success'
      else
        render 'failure'
      end
    else 
      @errors = @order.errors.messages
      Rails.logger.warn "#{@errors.inspect}"
      @final = true
      render 'delivery_info'
    end
  end
  
  def remove_item
    item = OrderedProduct.find(params[:id]).delete()
    redirect_to cart_path()
  end

  def invoice
    @order = Order.find(params[:id])
    validate_invoice
    if @order.status == "payed"
      respond_to do |format|
        format.html
        format.pdf do
          pdf = OrderPdf.new(@order, view_context)
          send_data pdf.render, filename: "order_#{@order.order_id}#{Date.today}.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
      end
    else
      redirect_to root_path
    end
  end

  private
    def authenticate_approved!
      if user_signed_in?
        authenticate_user!
      end

      if broker_signed_in?
        authenticate_broker!
      end

      unless current_active.approved?
        flash[:alert] = "You account is not yet approved"
        redirect_to root_path()
      end
    end

    def validate_invoice  
      if current_active && !current_active.has_order?(params[:id]) 
        flash[:notice] = "This is not your order!"
        return redirect_to root_path()
      end

      unless current_active
        flash[:notice] = "Please sign in first"
        return redirect_to root_path()
      end
    end

    def prepare_flash_errors(msgs)
      msgs.map { |m| "<li>#{m}</li>" }.join(" ")  
    end

    def safe_order_cc
      params.require(:order).permit(:name_on_card, :card_type, :card_number, :card_verification, :card_expires_on,
        :billing_address, :billing_city, :billing_prov, :billing_postal)
    end

    def validate_order(p)
      errors = []
      if p[:width].empty?
        errors << "Please enter width";
      end
      if p[:length].empty?
        errors << "Please enter length";
      end
      if p[:thickness_id].empty?
        errors << "Please select a thickness";
      end

      return errors
    end
end