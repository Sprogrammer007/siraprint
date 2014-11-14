class SliderImage < ActiveRecord::Base

  scope :large_format, -> { where(product_type: "large_format") }
  scope :metal_sign, -> { where(product_type: "metal_sign") }

  has_attached_file :slide_image, :default_url => "no-image.png"
  validates_attachment :slide_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] } 

end
