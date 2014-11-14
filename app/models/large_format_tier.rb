class LargeFormatTier < ActiveRecord::Base

  belongs_to :large_format_thickness

  attr_accessor :large_format_id

  scope :sqft_eq, -> (sqft) { where("min_sqft <= :sqft AND max_sqft >= :sqft", { :sqft => sqft }) }
end
