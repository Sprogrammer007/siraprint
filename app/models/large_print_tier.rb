class LargePrintTier < ActiveRecord::Base

	belongs_to :material_thickness

	attr_accessor :large_print_id

  scope :sqft_eq, -> (sqft) { where("min_sqft <= :sqft AND max_sqft >= :sqft", { :sqft => sqft }) }
end
