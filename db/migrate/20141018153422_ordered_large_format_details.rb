class OrderedLargeFormatDetails < ActiveRecord::Migration
  def change
    create_table :ordered_large_format_details do |t|
      t.integer :length
      t.integer :width
      t.integer :side
      t.integer :thickness_id
      t.string  :finishing
      t.integer :grommets_quantity
      t.string  :unit
    end
  end
end
