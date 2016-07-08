class AddSeoToProducts < ActiveRecord::Migration
  def change
    add_column :large_formats, :page_title, :string 
    add_column :large_formats, :meta_description, :string     
    add_column :metal_signs, :page_title, :string 
    add_column :metal_signs, :meta_description, :string     
    add_column :lcds, :page_title, :string 
    add_column :lcds, :meta_description, :string    
    add_column :plastic_cards, :page_title, :string 
    add_column :plastic_cards, :meta_description, :string 
  end
end
