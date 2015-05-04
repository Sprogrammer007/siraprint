class RemovePaperclip < ActiveRecord::Migration
  def change
    # remove_column :ordered_products, :print_pdf_content_type, :string
    # remove_column :ordered_products, :print_pdf_file_size, :integer
    # remove_column :ordered_products, :print_pdf_updated_at, :timestamp    

    # remove_column :ordered_products, :print_pdf_2_content_type, :string
    # remove_column :ordered_products, :print_pdf_2_file_size, :integer
    # remove_column :ordered_products, :print_pdf_2_updated_at, :timestamp   

    # remove_column :slider_images, :slide_image_content_type, :string
    # remove_column :slider_images, :slide_image_file_size, :integer
    # remove_column :slider_images, :slide_image_updated_at, :timestamp 
    

    # remove_column :large_formats, :display_image_content_type, :string
    # remove_column :large_formats, :display_image_file_size, :integer
    # remove_column :large_formats, :display_image_updated_at, :timestamp  

    # remove_column :metal_signs, :display_image_content_type, :string
    # remove_column :metal_signs, :display_image_file_size, :integer
    # remove_column :metal_signs, :display_image_updated_at, :timestamp  

    # remove_column :posts, :featured_image_content_type, :string
    # remove_column :posts, :featured_image_file_size, :integer
    # remove_column :posts, :featured_image_updated_at, :timestamp

    rename_column :ordered_products, :print_pdf_file_name, :print_pdf
    rename_column :ordered_products, :print_pdf_2_file_name, :print_pdf_2
  end
end
