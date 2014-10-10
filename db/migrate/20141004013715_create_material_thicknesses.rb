class CreateMaterialThicknesses < ActiveRecord::Migration
  def change
    create_table :material_thicknesses do |t|
    	t.references :large_print_material
    	t.integer :thickness
    	t.string :unit
    end
  end
end
