class MetalSign < ActiveRecord::Base

  has_many :metal_sign_sizes, :dependent => :destroy

  scope :active, -> { where(status: "Active") }
  scope :deactive, -> { where(status: "Deactive") }

  has_attached_file :display_image, :default_url => "no-image.png"
  validates_attachment :display_image, :presence => true,
  :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] } 

  accepts_nested_attributes_for :metal_sign_sizes
  
  delegate :active?, :deactive?, to: :current_state?

  def current_state?
    status.downcase.inquiry
  end

  def clone_with_associations
    new_record = self.dup
    new_record.save
    #sizes
    if self.metal_sign_sizes.any?
      self.metal_sign_sizes.each do |size|
        new_size = size.dup
        new_size.save
        new_size.update(:metal_sign_id => new_record.id)
      end
    end
    new_record
  end
end
