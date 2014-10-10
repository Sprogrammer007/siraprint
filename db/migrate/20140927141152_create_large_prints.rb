class CreateLargePrints < ActiveRecord::Migration
  def change
    create_table :large_prints do |t|
    	t.string :name
    	t.text :description
    	t.integer :sides
    	t.attachment :display_image
    	t.string :status

      t.timestamps
    end
  end
end
