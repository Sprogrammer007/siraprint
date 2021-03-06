class PlasticCardsController < ApplicationController
  
  before_filter :authenticate_all!, :except => [:index, :show, :get_price] 

  def index
    @plastic_cards = PlasticCard.all
    content_for :title, "Plastic Business Cards"
  end

  def show
    @plastic_card = PlasticCard.find(params[:id])
    content_for :title, @plastic_card.page_title
    content_for :meta, @plastic_card.meta_description
    @price = @plastic_card.plastic_card_prices.rate(1).first
  end

  
  def get_price
    @plastic_card = PlasticCard.find(params[:id])
    @price = @plastic_card.plastic_card_prices.rate(params[:q].to_i)
    if @price.first
      session[:current_rate] = @price.first.rate
    else
      session[:current_rate] = nil
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => @price.first }
    end
  end


end