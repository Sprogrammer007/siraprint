class StaticPagesController < ApplicationController
  
  def home
  end

  def about
    @no_sidebar = true
  end

  def help
    @no_sidebar = true
  end

  def contact
    @no_sidebar = true
  end

end