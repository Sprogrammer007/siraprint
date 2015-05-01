class DeliveryAddress < ActiveRecord::Base

  belongs_to :user
	belongs_to :broker

  attr_reader :order_form

  def html_address
    "<strong>#{self.full_name()}</strong><br/>#{self.address()}<br/>#{self.city()}, #{self.province()}<br/><span class='uppercase'>#{self.postal[0..2]} #{self.postal[3..5]}</span>"
  end

  def self.html_pickup_address
    "<strong>I'll Pickup My Orders</strong><br/>401 Magnetic Dr.<br/>Toronto, Ontario <br/><span class='uppercase'>M3J 3H9</span>"
  end

end
