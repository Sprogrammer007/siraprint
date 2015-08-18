class OrderedProductsController < ApplicationController
  
  before_filter :authenticate_all!

  def update
    @op = OrderedProduct.find(params[:id])
    if @op
      @op.update(permitted_params)
    end
    respond_to do |format|
      format.html 
      format.json { render :json => { success: true} }
    end
  end

  def upload
    @op = OrderedProduct.find(params[:id])
    @side = (params[:side].to_i || 1)
    respond_to do |format|
      format.html 
      format.js
    end
  end
  
  def destroy
    OrderedProduct.find(params[:id]).destroy
    respond_to do |format|
      format.html 
      format.json { render :json => { success: true} }
    end
  end

  private
    def permitted_params
      params.require(:ordered_product).permit(:print_pdf, :print_pdf_2)
    end

end