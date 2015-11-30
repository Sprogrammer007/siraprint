class LcdTier < ActiveRecord::Base

  belongs_to :lcd_thickness

  attr_accessor :lcd_id

  scope :sqft_eq, -> (sqft) { where("min_sqft <= :sqft AND max_sqft >= :sqft", { :sqft => sqft }) }
end
