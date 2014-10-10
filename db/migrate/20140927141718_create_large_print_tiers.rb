class CreateLargePrintTiers < ActiveRecord::Migration
  def change
    create_table :large_print_tiers do |t|
    	t.references :material_thickness
    	t.string :level
    	t.integer :min_sqft
    	t.integer :max_sqft
    	t.decimal :price
    end
  end
end
