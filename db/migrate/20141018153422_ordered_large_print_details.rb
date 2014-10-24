class OrderedLargePrintDetails < ActiveRecord::Migration
  def change
    create_table :ordered_large_print_details do |t|
      t.integer :length
      t.integer :width
      t.integer :material_id
      t.integer :thickness_id
      t.string  :unit
    end
  end
end
