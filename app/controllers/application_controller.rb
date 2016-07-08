class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
  	if resource.class == AdminUser
  		admin_root_path()
    else
    	root_path()
    end
  end

  def current_active
    active_user = current_broker || current_user
    return active_user
  end

  def active_signed_in?
    return broker_signed_in? || user_signed_in?
  end
  # FORCE to implement content_for in controller
  def view_context
    super.tap do |view|
      (@_content_for || {}).each do |name,content|
        view.content_for name, content
      end
    end
  end
  def content_for(name, content) # no blocks allowed yet
    @_content_for ||= {}
    if @_content_for[name].respond_to?(:<<)
      @_content_for[name] << content
    else
      @_content_for[name] = content
    end
  end
  def content_for?(name)
    @_content_for[name].present?
  end
  private
    def authenticate_all!
      if user_signed_in?
        return authenticate_user!
      end
      if broker_signed_in?
        return authenticate_broker!
      end
      flash[:alert] = "You must sign in before continue."
      redirect_to root_path()
    end

end
