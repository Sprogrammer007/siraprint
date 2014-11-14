class CreateLargeFormatThicknesses < ActiveRecord::Migration
  def change
    create_table :large_format_thicknesses do |t|
      t.references :large_format
      t.integer :thickness
      t.string :unit
    end
  end
end
