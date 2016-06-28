class MetalSign < ActiveRecord::Base

  has_many :metal_sign_sizes, :dependent => :destroy

  scope :active, -> { where(status: "Active") }
  scope :deactive, -> { where(status: "Deactive") }

  mount_uploader :display_image_file_name, MetalSignDisplayUploader
  validates_presence_of :display_image_file_name 
  accepts_nested_attributes_for :metal_sign_sizes
  
  delegate :active?, :deactive?, to: :current_state?

  def name_for_db
    if self.name
      self.name.downcase.split(" ").join("_")
    end
  end
  def has_video?
    
    !self.video.nil?
  end

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
