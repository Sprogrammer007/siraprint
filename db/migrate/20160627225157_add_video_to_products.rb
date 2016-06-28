class AddVideoToProducts < ActiveRecord::Migration
  def change
    add_column :large_formats, :video, :string 
    add_column :metal_signs, :video, :string 
    add_column :plastic_cards, :video, :string 
    add_column :lcds, :video, :string 
  end
end
