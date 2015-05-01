class DeliveryAddressesController < ApplicationController
  
  before_filter :authenticate_all!
  before_filter :safe_params, :only => :create

	def new
		@daddress = DeliveryAddress.new()
	end

	def create
    address = current_active.delivery_addresses.create!(safe_params)
    if params[:order_form]
      redirect_to select_delivery_order_path(delivery_address_id: address.id, method: "Deliver")
    else
  		redirect_to profile_path(current_active)
    end
	end

  def edit
    @daddress = DeliveryAddress.find(params[:id])
  end

  def update
    @daddress = DeliveryAddress.find(params[:id])
    @daddress.update(safe_params)
    if params[:delivery_address][:order_form]
      redirect_to delivery_info_path()
    else
      redirect_to profile_path(current_active)
    end
  end

  def destroy
    @daddress = DeliveryAddress.find(params[:id]).destroy
    if params[:order_form]
      redirect_to delivery_info_path()
    else
      redirect_to profile_path(current_active)
    end
  end

	private

		def safe_params
      params.require(:delivery_address).permit(:full_name, :address,
       :province, :city, :postal)
    end
end