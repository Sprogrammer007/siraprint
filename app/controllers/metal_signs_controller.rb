class MetalSignsController < ApplicationController
  
  before_filter :authenticate_all!, :except => [:index, :show, :get_thickness, :get_price] 

  def index
    @metal_signs = MetalSign.all

  end

  def show
    @metal_sign = MetalSign.find(params[:id])
    content_for :title, @metal_sign.page_title
    content_for :meta, @metal_sign.meta_description
  end

  
  def get_price
    @metal_sign_size = MetalSignSize.find(params[:s_id])
    if @metal_sign_size
      session[:current_rate] = @metal_sign_size.price
    else
      session[:current_rate] = nil
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @metal_sign_size }
    end
  end

end