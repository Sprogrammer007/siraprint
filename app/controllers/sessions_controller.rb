class SessionsController < Devise::SessionsController
  
  def new
    @no_sidebar = true
    super
  end
end