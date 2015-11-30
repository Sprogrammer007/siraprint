class LcdsController < ApplicationController
  
  before_filter :authenticate_all!, :except => [:index, :show, :get_thickness, :get_price, :change_side] 

  def index
    @lcds = Lcd.all
  end

  def show
    @lcd = Lcd.find(params[:id])
    @none = @lcd.lcd_finishings.has_none.any?
  end
  
  def get_price
    thickness = LcdThickness.find(params[:t_id])
    sqft = params[:sqft].to_f.round(2)
    Rails.logger.warn("#{sqft} sqft")
    @price = thickness.lcd_tiers.sqft_eq(sqft)
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