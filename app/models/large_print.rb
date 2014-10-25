class LargePrint < ActiveRecord::Base

	has_many :large_print_materials
	
  scope :active, -> { where(status: "Active") }
  scope :deactive, -> { where(status: "Deactive") }

	has_attached_file :display_image, :default_url => "no-image.png"
  validates_attachment :display_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] }	

  delegate :active?, :deactive?, to: :current_state?

  def current_state?
    status.downcase.inquiry
  end
end
