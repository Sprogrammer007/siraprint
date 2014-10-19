class OrdersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :create] 

  def create
    Rails.logger.warn "#{params}"
    
    @order = current_user.new_order
    @order.ordered_products.create!(quantity: params[:quantity], product_type: params[:product_type],
      print_pdf: params[:design_pdf])
    redirect_to :back
  end
end