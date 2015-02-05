class StaticPagesController < ApplicationController
  
  def home
  end

  def about

  end

  def help
    @posts = Post.all()
  end

  def contact
  end

  def privacy
  end

  def terms
  end
  
  def ud
    render :layout => false
  end

end