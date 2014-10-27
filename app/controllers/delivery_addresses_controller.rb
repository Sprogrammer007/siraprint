class DeliveryAddressesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :safe_params, :only => :create

	def new
		@daddress = DeliveryAddress.new()
	end

	def create
		current_user.delivery_addresses.create!(safe_params)
		redirect_to user_path(current_user)
	end

  def edit
    @daddress = DeliveryAddress.find(params[:id])
  end

  def update
    @daddress = DeliveryAddress.find(params[:id])
    @daddress.update(safe_params)

    redirect_to user_profile_path(@daddress.user_id)
  end

  def destroy
    id = @daddress.user_id
    @daddress = DeliveryAddress.find(params[:id]).destroy

    redirect_to user_profile_path(id)
  end

	private

		def safe_params
      params.require(:delivery_address).permit(:full_name, :address,
       :province, :city, :postal)
    end
end