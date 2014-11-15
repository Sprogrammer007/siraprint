class UsersController < Devise::RegistrationsController

  respond_to :html, :js

  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters
  
  def new
    @no_sidebar = true
    super
  end

  def create
    @no_sidebar = true
    super
  end

  def show
    @no_sidebar = true
    unless user_signed_in?
      set_flash_message :alert, :not_signed_in
      redirect_to root_path()
    end
  end

  def edit
    @no_sidebar = true
    @resource = resource
  end

  def after_sign_up
  end

  def my_orders
    @no_sidebar = true
    @orders = current_user.orders
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
end