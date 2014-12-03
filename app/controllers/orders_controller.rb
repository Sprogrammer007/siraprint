class OrdersController < ApplicationController
  
  before_filter :authenticate_user!

  def create
    oparams = params[:order]
    @order = current_user.open_order || current_user.new_order(request.remote_ip)
    if @order
      op = @order.create_new_ordered_product(oparams)
      if op.save
        detail =  op.create_details(oparams[:product_type], oparams[:details])
        if detail.save
          op.update(:product_detail_id => detail.id)
        else
          flash[:warn] = "Oh no! Your order did not go through. Please make sure you provided all required informations!"
          redirect_to :back and return
        end
      else
        flash[:warn] = "Oh no! Your order did not go through. Please make sure you provided all required informations!"
        redirect_to :back and return
      end
      @order.update_price
    else
    end
    redirect_to cart_path()
  end

  def show
    @order = current_user.open_order
    @order.update_price
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
      da = DeliveryAddress.find(params[:delivery_adress_id])
      @order.update!(delivery_address: da.html_address, delivery_method: params[:method])
    end
    redirect_to check_out_order_path(@order)
  end

  def check_out
    @order = current_user.open_order
    @order.update_price
  end

  def express
    @order = Order.find(params[:id])
    response = EXPRESS_GATEWAY.setup_purchase(@order.price_in_cents,
      :items => [{:name => "Sira Print Order ##{@order.order_id}", :description => @order.get_description, :amount => @order.price_in_cents}],
      :ip                => @order.ip_address,
      :return_url        => confirm_order_url(id: @order.id),
      :cancel_return_url => root_url
    )

    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def confirm
    @order = Order.find(params[:id])
    @order.update(:express_token => params[:token])
    if @order.purchase
      OrderMailer.notify_order_placed(current_user, @order).deliver
      OrderMailer.thank_you_for_order(current_user, @order).deliver
      render 'success'
    else
      render 'failure'
    end
  end
  
  def remove_item
    item = OrderedProduct.find(params[:id]).delete()
    redirect_to cart_path()
  end


end