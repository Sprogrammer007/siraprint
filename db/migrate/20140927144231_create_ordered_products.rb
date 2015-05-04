class CreateOrderedProducts < ActiveRecord::Migration
  def change
    create_table :ordered_products do |t|
      t.references :order
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :price
      t.string :print_pdf_file_name
      t.string :print_pdf_2_file_name
      t.string :product_type
      t.integer :product_detail_id
      t.integer :product_id
      t.timestamps
    end
  end
end
