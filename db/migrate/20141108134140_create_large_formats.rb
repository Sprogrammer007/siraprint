class CreateLargeFormats < ActiveRecord::Migration
  def change
    create_table :large_formats do |t|
      t.string :name
      t.text :description
      t.integer :sides
      t.string :display_image_file_name
      t.string :status
      
      t.timestamps
    end
  end
end
