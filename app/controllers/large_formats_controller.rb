class LargeFormatsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :get_thickness, :get_price] 

  def index
  	@large_formats = LargeFormat.where(:sides => params[:sides])
  end

  def show
    @large_format = LargeFormat.find(params[:id])
    @no_sidebar = true
  end

  
  def get_price
    thickness = LargeFormatThickness.find(params[:id])
    sqft = params[:sqft].to_f.round
    @price = thickness.large_format_tiers.sqft_eq(sqft)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @price.first }
    end
  end
end