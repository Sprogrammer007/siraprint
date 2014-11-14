class CreateMetalSignSizes < ActiveRecord::Migration
  def change
    create_table :metal_sign_sizes do |t|
      t.references :metal_sign
      t.integer :width
      t.integer :height
      t.string :unit
      t.decimal :price

    end
  end
end
