class RegistrationsController < Devise::RegistrationsController

  protected

    def after_inactive_sign_up_path_for(resource)
    	if resource.approved
    		redirect_to :controller => "users", :action => "show", :id => resource
    	end
    	redirect_to user_after_sign_up_path(resource)
    end
end