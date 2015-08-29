class CreatePlasticCards < ActiveRecord::Migration
  def change
    create_table :plastic_cards do |t|
      t.string :name
      t.text :description
      t.integer :broker_discount, default: 0
      t.string :display_image_file_name
      t.string :status
      
      t.timestamps
    end
  end
end
