class LargePrintMaterial < ActiveRecord::Base

	belongs_to :large_print
	has_many :material_thicknesses
	accepts_nested_attributes_for :material_thicknesses, :reject_if => :all_blank, :allow_destroy => true
	
	has_attached_file :material_image, :default_url => "no-image.png"
  validates_attachment :material_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
end
