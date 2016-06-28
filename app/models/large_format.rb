class LargeFormat < ActiveRecord::Base

  has_many :large_format_thicknesses, :dependent => :destroy
  has_many :finishing_options
  has_many :large_format_finishings, :through => :finishing_options, :dependent => :destroy

  scope :active, -> { where(status: "Active") }
  scope :deactive, -> { where(status: "Deactive") }
  scope :side, -> (n) { where(sides: n) }
  mount_uploader :display_image_file_name, LargeFormatDisplayUploader
  validates_presence_of :display_image_file_name
  accepts_nested_attributes_for :large_format_thicknesses, :allow_destroy => true

  delegate :active?, :deactive?, to: :current_state?

  def current_state?
    status.downcase.inquiry
  end
  
  def has_video?
    
    !self.video.nil?
  end
  
  def name_for_db
    if self.name
      self.name.downcase.split(" ").delete_if { |n| n == "+" }.join("_")
    end
  end

  def side_options
    [["1 side 4/0", 1], ["2 side 4/4", 2]]
  end
  

  def clone_with_associations
    new_record = self.dup
    new_record.save
    #thickness
    if self.large_format_thicknesses.any?
      self.large_format_thicknesses.each do |thickness|
        new_thickness = thickness.dup
        new_thickness.save
        new_thickness.update(:large_format_id => new_record.id)

        #tiers
        if thickness.large_format_tiers.any?
          thickness.large_format_tiers.each do |tier|
            new_tier = tier.dup
            new_tier.save
            new_tier.update(:large_format_thickness_id => thickness.id)
          end
        end
      end
    end
    new_record
  end
end
