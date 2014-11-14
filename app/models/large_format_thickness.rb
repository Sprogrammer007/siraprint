class LargeFormatThickness < ActiveRecord::Base

  belongs_to :large_format
  has_many :large_format_tiers, :dependent => :destroy

  accepts_nested_attributes_for :large_format_tiers, :allow_destroy => true

end
