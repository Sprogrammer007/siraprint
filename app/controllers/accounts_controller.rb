class AccountsController < ApplicationController
  before_filter :authenticate_all!
  
  def show
    @user = current_active
  end


  def cancel
    if current_active.status == "Approved"
      current_active.update!(status: "Canceled")
      sign_out(current_active)
      redirect_to root_path
    else
      flash[:alert] = "You cannot cancel this account!"
      redirect_to :back
    end
  end

  def my_orders
    if active_signed_in? && current_active.approved?
      @orders = current_active.orders
    else
      flash[:alert] = "You cannot access this page, please sign in first!"
      redirect_to root_path()
    end
  end


end