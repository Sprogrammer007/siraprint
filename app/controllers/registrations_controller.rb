class RegistrationsController < Devise::RegistrationsController

  protected

    def after_inactive_sign_up_path_for(resource)
    	if resource.approved
    		redirect_to :controller => "accounts", :action => "show", :id => resource
    	end
    	redirect_to broker_after_sign_up_path(resource)
    end


end