class LargePrintsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :get_thickness, :get_price] 

  def index
  	@large_prints = LargePrint.all
  end

  def show
    @large_print = LargePrint.find(params[:id])
  end

  def get_thickness
    material = LargePrintMaterial.find(params[:id])
    @thicknesses = material.material_thicknesses

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
  

  def get_price
    thickness = MaterialThickness.find(params[:id])
    @price = thickness.large_print_tiers.sqft_eq(2)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @price.first }
    end
  end
end