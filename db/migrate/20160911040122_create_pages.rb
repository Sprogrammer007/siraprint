class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.timestamps
    end
    create_table :page_contents do |t|
      t.integer :page_id
      t.string :name
      t.text :content
      t.string :image_file_name 
      t.string :link 
    
    end
  end
end
