class MetalSignsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :get_thickness, :get_price] 

  def index
    @metal_signs = MetalSign.all
  end

  def show
    @metal_sign = MetalSign.find(params[:id])
    @no_sidebar = true
  end

  
  def get_price


  end
end