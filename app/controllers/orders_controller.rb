class OrdersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index] 

  def create
    oparams = params[:order]
    @order = current_user.open_order || current_user.new_order
    if @order
      op = @order.ordered_products.create(quantity: oparams[:quantity], product_type: oparams[:product_type],
        print_pdf: oparams[:design_pdf], product_id: oparams[:product_id], unit_price: oparams[:unit_price],
        price: oparams[:total_price] )
      if op.save!
        op.create_details(oparams[:product_type], oparams[:details])
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

  def payment
  end
  
  def remove_item
    item = OrderedProduct.find(params[:id]).delete()
    redirect_to cart_path()
  end


end