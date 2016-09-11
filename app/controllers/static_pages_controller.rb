class StaticPagesController < ApplicationController
  
  def home
    @page =  Page.home[0]
    @main_content
    @subs = []
    @page.page_contents.each do |c|
      @main_content = c if c.name == 'main'
     
      if (c.name == 'sub1' || c.name == 'sub2' || c.name =='sub3')
        @subs << c 
      end
    end
    
   
  end

  def about
    @page =  Page.about[0]
    @main_content
     content_for :title, "About Us"
    @page.page_contents.each do |c|
      @main_content = c if c.name == 'main' 
      
    end
    
  
  
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