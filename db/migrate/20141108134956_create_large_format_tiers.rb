class CreateLargeFormatTiers < ActiveRecord::Migration
  def change
    create_table :large_format_tiers do |t|

      t.references :large_format_thickness
      t.string :level
      t.integer :min_sqft
      t.integer :max_sqft
      t.decimal :price
    end
  end
end
