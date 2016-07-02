class StaticPagesController < ApplicationController
  
  def home

  end

  def about

  end


  def help
    @posts = Post.all()
  end
  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end
  def portfolio
    
  end

  def contact
  end

  def contact_submit
    UserMailer.contact(params[:info]).deliver
    flash[:notice] = "Thanks, your comments has been submited!"
    redirect_to root_path()
  end
  
  def privacy
  end

  def terms
  end
  
  def ud
    render :layout => false
  end

end