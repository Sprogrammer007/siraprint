class LargeFormat < ActiveRecord::Base

  has_many :large_format_thicknesses, :dependent => :destroy
  
  scope :active, -> { where(status: "Active") }
  scope :deactive, -> { where(status: "Deactive") }

  has_attached_file :display_image, :default_url => "no-image.png"
  validates_attachment :display_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] } 

  accepts_nested_attributes_for :large_format_thicknesses, :allow_destroy => true

  delegate :active?, :deactive?, to: :current_state?
  
  def current_state?
    status.downcase.inquiry
  end
end
