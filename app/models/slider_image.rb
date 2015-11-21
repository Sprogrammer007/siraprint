class SliderImage < ActiveRecord::Base

  scope :large_format, -> { where(product_type: "large_format") }
  scope :metal_sign, -> { where(product_type: "metal_sign") }
  scope :home, -> { where(product_type: "home") }
  scope :portfolio, -> { where(product_type: "portfolio") }

  mount_uploader :slide_image_file_name, SliderImageUploader
  validates_presence_of :slide_image_file_name 
end
