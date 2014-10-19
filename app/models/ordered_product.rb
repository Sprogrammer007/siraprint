class OrderedProduct < ActiveRecord::Base
  
  belongs_to :order

  has_attached_file :print_pdf, :default_url => "no-image.png"
  validates_attachment :print_pdf, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  
  def order_details

  end
end
