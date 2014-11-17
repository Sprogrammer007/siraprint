class OrdersController < ApplicationController
  
  before_filter :authenticate_user!

  def create
    oparams = params[:order]
    @order = current_user.open_order || current_user.new_order
    if @order
      op = @order.ordered_products.create(quantity: oparams[:quantity], product_type: oparams[:product_type],
        print_pdf: oparams[:design_pdf], print_pdf_2: oparams[:design_pdf_2], product_id: oparams[:product_id], unit_price: oparams[:unit_price],
        price: oparams[:total_price] )
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
    @no_sidebar = true
    @order = current_user.open_order
    @order.update_price
  end

  def delivery_info
    @no_sidebar = true
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

  def payment
  end
  
  def remove_item
    item = OrderedProduct.find(params[:id]).delete()
    redirect_to cart_path()
  end


end