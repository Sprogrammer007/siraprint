class OrderedLargePrintDetails < ActiveRecord::Migration
  def change
    create_table :ordered_large_print_details do |t|
      t.integer :length
      t.integer :width
      t.integer :sqft
      t.string :material
      t.integer :thickness
      t.string :tier
    end
  end
end
