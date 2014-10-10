class LargePrintsController < ApplicationController
  
  before_filter :authenticate_user!, :except => :index

  def index
  	@large_prints = LargePrint.all
  end

end