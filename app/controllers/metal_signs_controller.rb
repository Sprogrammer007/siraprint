class MetalSignsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :get_thickness, :get_price] 

  def index
    @metal_signs = MetalSign.all
  end

  def show
    @metal_sign = MetalSign.find(params[:id])
  end

  
  def get_price
    @metal_sign_size = MetalSignSize.find(params[:s_id])
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @metal_sign_size }
    end
  end

end