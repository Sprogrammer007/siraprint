class UsersController < Devise::RegistrationsController

  respond_to :html, :js

  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters
  
  def new
    super
  end


  def show
    unless user_signed_in?
      set_flash_message :alert, :not_signed_in
      redirect_to root_path()
    end
  end

  def edit
    @resource = resource
  end

  def cancel
    if current_user.status == "Approved"
      current_user.update!(status: "Canceled")
      sign_out(current_user)
      redirect_to root_path
    else
      flash[:alert] = "You cannot cancel this account!"
      redirect_to :back
    end
  end

  def my_orders
    if user_signed_in? && current_user.approved?
      @orders = current_user.orders
    else
      flash[:alert] = "You cannot access this page, please sign in first!"
      redirect_to root_path()
    end
  end

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation,
        :company_name, :company_province, :company_postal,
        :company_address, :company_city, :company_hst, :company_phone)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:email, :password, :password_confirmation,
        :company_name, :company_province, :company_postal,
        :company_address, :company_city, :company_hst,
        :current_password, :company_phone)
    end
  end

  def after_sign_up_path_for(resource)
    UserMailer.notify_new_user(resource).deliver
    UserMailer.signup_welcome(resource).deliver
    return root_path
  end
end