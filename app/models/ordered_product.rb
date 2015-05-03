class OrderedProduct < ActiveRecord::Base
  
  belongs_to :order

  scope :large_format, -> { where(product_type: "large_format") }
  scope :metal_sign, -> { where(product_type: "metal_sign") }
  
  before_destroy :remove_details
  def details
    "Ordered#{self.product_type.camelize.gsub("_", "")}Detail".constantize.find(self.product_detail_id)
  end

  def product
    "#{self.product_type.camelize.gsub("_", "")}".constantize.find(self.product_id)
  end

  def create_details(type, details)
    detail = "Ordered#{type.camelize.gsub("_", "")}Detail".constantize.new(details.permit!)
    return detail
  end

  def pro_type
    self.product_type.camelize.split("_").join(" ")
  end

  def price_in_cents
    (self.unit_price*100).round()
  end

  def remove_details
    self.details.destroy
  end

end
