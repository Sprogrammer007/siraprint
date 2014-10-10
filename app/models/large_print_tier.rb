class LargePrintTier < ActiveRecord::Base

	belongs_to :material_thickness

	attr_accessor :large_print_id
end
