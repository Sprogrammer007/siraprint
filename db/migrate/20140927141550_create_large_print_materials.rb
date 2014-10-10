class CreateLargePrintMaterials < ActiveRecord::Migration
  def change
    create_table :large_print_materials do |t|
    	t.references :large_print
    	t.string :material_name
    	t.attachment :material_image
    end
  end
end
