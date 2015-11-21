class SliderImage < ActiveRecord::Base

  scope :large_format, -> { where(product_type: "large_format") }
  scope :metal_sign, -> { where(product_type: "metal_sign") }
  scope :home, -> { where(product_type: "home") }
  scope :portfolio, -> { where(product_type: "portfolio") }

  mount_uploader :slide_image_file_name, SliderImageUploader
  validates_presence_of :slide_image_file_name 
  # Prevent modification of existing records
  def readonly?
     !new_record?
  end

  # Prevent objects from being destroyed
  def before_destroy
    raise ActiveRecord::ReadOnlyRecord
  end
end
