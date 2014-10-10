class LargePrint < ActiveRecord::Base

	has_many :large_print_materials
	
	has_attached_file :display_image, :default_url => "no-image.png"
  validates_attachment :display_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }	
end
