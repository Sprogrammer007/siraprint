class CreateOrderedMetalSignDetails < ActiveRecord::Migration
  def change
    create_table :ordered_metal_sign_details do |t|
      t.integer :size_id
    end
  end
end
