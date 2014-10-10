class CreateMetalSigns < ActiveRecord::Migration
  def change
    create_table :metal_signs do |t|
    	t.string :name
    	t.text :description
    	t.attachment :display_image
    	t.string :status

      t.timestamps
    end
  end
end
