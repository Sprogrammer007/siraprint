class AddProcessingOrderedProduct < ActiveRecord::Migration
  def change
    add_column :ordered_products, :print_pdf_processing, :boolean
    add_column :ordered_products, :print_pdf_2_processing, :boolean
  end
end
