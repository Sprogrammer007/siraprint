class StaticPagesController < ApplicationController
  
  def home

  end

  def about
   content_for :title, "About Us"
  
  end


  def help
    @posts = Post.all()
  end
  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end
  def   
    
  def sitemap
    respond_to :xml
    expires_in 6.hours, public: true
  end
  def portfolio
    
  end

  def contact
        content_for :title, "Contact Us"
  end

  def contact_submit
    UserMailer.contact(params[:info]).deliver
    flash[:notice] = "Thanks, your comments has been submited!"
    redirect_to root_path()
  end
  
  def privacy
        content_for :title, "Privacy Policy"
  end

  def terms
    content_for :title, "Terms of Use"
  end
  
  def ud
    render :layout => false
  end

end