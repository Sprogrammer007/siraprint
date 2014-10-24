class OrderedProduct < ActiveRecord::Base
  
  belongs_to :order

  has_attached_file :print_pdf, :default_url => "no-image.png"
  validates_attachment :print_pdf, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  
  def details
    "Ordered#{self.product_type.camelize.gsub("_", "")}Detail".constantize.find(self.product_detail_id)
  end

  def product
    "#{self.product_type.camelize.gsub("_", "")}".constantize.find(self.product_id)
  end

  def create_details(type, details)
    detail = "Ordered#{type.camelize.gsub("_", "")}Detail".constantize.new(details.permit!)
    detail.save!
    self.update(:product_detail_id => detail.id)   
  end

  def remove
    self.details.destroy
    self.destroy
  end

end
