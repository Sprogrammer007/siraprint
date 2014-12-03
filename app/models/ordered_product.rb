class OrderedProduct < ActiveRecord::Base
  
  belongs_to :order

  has_attached_file :print_pdf, :default_url => "no-image.png"
  validates_attachment :print_pdf, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  
  has_attached_file :print_pdf_2, :default_url => "no-image.png"
  validates_attachment :print_pdf_2, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  

  scope :large_format, -> { where(product_type: "large_format") }
  scope :metal_sign, -> { where(product_type: "metal_sign") }
  
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

  def remove
    self.details.destroy
    self.destroy
  end

end
