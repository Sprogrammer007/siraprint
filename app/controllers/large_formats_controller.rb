class LargeFormatsController < ApplicationController
  
  before_filter :authenticate_all!, :except => [:index, :show, :get_thickness, :get_price, :change_side] 

  def index
  	@large_formats = LargeFormat.all
  end

  def show
    @large_format = LargeFormat.find(params[:id])
    @none = @large_format.large_format_finishings.has_none.any?
  end
  
  def get_price
    thickness = LargeFormatThickness.find(params[:t_id])
    sqft = params[:sqft].to_f.round(2)
    Rails.logger.warn("#{sqft} sqft")
    @price = thickness.large_format_tiers.sqft_eq(sqft)
    Rails.logger.warn(@price.inspect)
    if @price.first
      session[:current_rate] = @price.first.price
    else
      session[:current_rate] = nil
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @price.first }
    end
  end


end