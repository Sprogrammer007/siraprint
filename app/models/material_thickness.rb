class MaterialThickness < ActiveRecord::Base

	belongs_to :large_print_material
	has_many :large_print_tiers, :dependent => :destroy
	accepts_nested_attributes_for :large_print_tiers

	attr_accessor :large_print_id
end
    