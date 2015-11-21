class AddCompanyNameToSlider < ActiveRecord::Migration
  def change
    add_column :slider_images, :company_name, :string 
    add_column :slider_images, :company_website, :string 
    remove_column :slider_images, :updated_at, :datetime 
  end
end
