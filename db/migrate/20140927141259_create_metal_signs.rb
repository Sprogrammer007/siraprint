class CreateMetalSigns < ActiveRecord::Migration
  def change
    create_table :metal_signs do |t|
    	t.string :name
    	t.text :description
    	t.string :display_image_file_name
    	t.string :status

      t.timestamps
    end
  end
end
