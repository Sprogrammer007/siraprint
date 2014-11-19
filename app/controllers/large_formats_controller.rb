class LargeFormatsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :get_thickness, :get_price, :change_side] 

  def index
  	@large_formats = LargeFormat.side(1)
  end

  def show
    @large_format = LargeFormat.find(params[:id])
  end

  def change_side
    @large_format = LargeFormat.where(name: params[:name], sides: params[:side])[0]
  end
  
  def get_price
    thickness = LargeFormatThickness.find(params[:id])
    sqft = params[:sqft].to_f.round(2)
    @price = thickness.large_format_tiers.sqft_eq(sqft)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @price.first }
    end
  end
end