class RemovePaperclip < ActiveRecord::Migration
  def change
    rename_column :ordered_products, :print_pdf_file_name, :print_pdf
    rename_column :ordered_products, :print_pdf_2_file_name, :print_pdf_2
  end
end
