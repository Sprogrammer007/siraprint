class DeliveryAddress < ActiveRecord::Base

	belongs_to :user

  attr_reader :order_form

  def html_address
    "<strong>#{self.full_name()}</strong><br/>#{self.address()}<br/>#{self.city()}, #{self.province()}<br/><span class='uppercase'>#{self.postal[0..2]} #{self.postal[3..5]}</span>"
  end
end
