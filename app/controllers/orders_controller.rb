class OrdersController < ApplicationController
  
  before_filter :authenticate_approved_user!, except: [:invoice]

  def create
    oparams = params[:order]
    @order = current_user.open_order || current_user.new_order(request.remote_ip)
    if @order
      
      op = @order.create_new_ordered_product(oparams, session[:current_rate])
      if op.save
        detail = op.create_details(oparams[:product_type], oparams[:details])
        if detail.save
          op.update(:product_detail_id => detail.id)
        else
          flash[:danger] = "<ul>#{prepare_flash_errors(detail.errors.full_messages) }</ul>"
          redirect_to :back and return
        end
      else
        flash[:danger] = "<ul>#{prepare_flash_errors(op.errors.full_messages) }</ul>"
        redirect_to :back and return
      end
      @order.update_price
    end
    session[:current_rate] = nil
    redirect_to cart_path()
  end

  def show
    if current_user.open_order && current_user.open_order.ordered_products.any?
      @order = current_user.open_order
      @order.update_price
    end
  end

  def delivery_info
    @order = current_user.open_order
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
    @order = current_user.open_order
    @order.update_price
    # @final = true
    # render 'delivery_info'
  end

  ## TO BE REMOVE LATER
  def express
    @order = Order.find(params[:id])
    response = EXPRESS_GATEWAY.setup_purchase(@order.total_in_cents,
      :items                => @order.prepare_paypal_items,
      :subtotal             => @order.sub_total_in_cents,
      :tax                  => @order.tax_in_cents,
      :currency             => 'CAD',
      :shipping             => 0,
      :handling             => 0,
      :no_shipping          => true,
      :allow_guest_checkout => true
      :ip                   => @order.ip_address,
      :return_url           => confirm_order_url(id: @order.id),
      :cancel_return_url    => root_url
    )
    Rails.logger.warn "#{response.inspect}"
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  # To be removed
  def confirm
    @order = Order.find(params[:id])
    @order.update(:express_token => params[:token])
    if @order.purchase
      OrderMailer.notify_order_placed(current_user, @order).deliver_now
      OrderMailer.thank_you_for_order(current_user, @order).deliver_now
      @order.update(:ordered_date => Date.today)
      render 'success'
    else
      render 'failure'
    end
  end

  # def pay
  #   @order = current_user.open_order
  #   @order.final = true
  #   if @order.update(safe_order_cc)
  #     if @order.purchase
  #       OrderMailer.notify_order_placed(current_user, @order).deliver_now
  #       OrderMailer.thank_you_for_order(current_user, @order).deliver_now
  #       render 'success'
  #     else
  #       render 'failure'
  #     end
  #   else 
  #     @errors = @order.errors.messages
  #     Rails.logger.warn "#{@errors.inspect}"
  #     @final = true
  #     render 'delivery_info'
  #   end
  # end
  
  def remove_item
    item = OrderedProduct.find(params[:id]).delete()
    redirect_to cart_path()
  end

  def invoice
    @order = Order.find(params[:id])
    validate_order
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
    def authenticate_approved_user!
      authenticate_user!
      unless current_user.approved?
        flash[:alert] = "You account is not yet approved"
        redirect_to root_path()
      end
    end

    def validate_order
          
      if current_user && !current_user.has_order?(params[:id]) 
        flash[:notice] = "This is not your order!"
        return redirect_to new_user_session_path()
      end

      unless current_user
        flash[:notice] = "Please sign in first"
        return redirect_to new_user_session_path()
      end
    end

    def prepare_flash_errors(msgs)
      msgs.map { |m| "<li>#{m}</li>" }.join(" ")  
    end

    def safe_order_cc
      params.require(:order).permit(:name_on_card, :card_type, :card_number, :card_verification, :card_expires_on,
        :billing_address, :billing_city, :billing_prov, :billing_postal)
    end
end