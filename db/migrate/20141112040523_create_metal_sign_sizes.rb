class CreateMetalSignSizes < ActiveRecord::Migration
  def change
    create_table :metal_sign_sizes do |t|
      t.references :metal_sign
      t.decimal :width
      t.decimal :height
      t.string :unit
      t.decimal :price

    end
  end
end
