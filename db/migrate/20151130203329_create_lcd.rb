class CreateLcd < ActiveRecord::Migration
  def change
    create_table :lcds do |t|
      t.string :name
      t.text :description
      t.decimal :max_width
      t.decimal :max_length
      t.integer :broker_discount
      t.boolean :has_two_side
      t.string :display_image_file_name
      t.string :status
      t.timestamps
    end
    create_table :lcd_thicknesses do |t|
      t.references :lcd
      t.decimal :thickness
      t.string :unit
    end
    create_table :lcd_tiers do |t|
      t.references :lcd_thickness
      t.string :level
      t.integer :min_sqft
      t.integer :max_sqft
      t.decimal :price
    end
    create_table :lcd_finishings do |t|
      t.string :name
    end
    create_table :lcd_finishing_options, :id => false do |t|
      t.references :lcd, index: true
      t.references :lcd_finishing, index: true
    end
    create_table :ordered_lcd_details do |t|
      t.integer :length
      t.integer :width
      t.integer :side
      t.integer :thickness_id
      t.string  :finishing
      t.string  :unit
    end
  end
end