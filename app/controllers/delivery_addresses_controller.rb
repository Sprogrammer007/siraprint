class DeliveryAddressesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :safe_params, :only => :create


	def new
		@daddress = DeliveryAddress.new()
	end

	def create
		current_user.delivery_addresses.create!(safe_params)
		redirect_to show_user_path(current_user)
	end

	private
		def safe_params
      params.require(:delivery_address).permit(:address,
       :province, :city, :postal)
    end
end