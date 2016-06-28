class RemoveCompanyFromSlider < ActiveRecord::Migration
  def change
    remove_column :slider_images, :company_name 
    remove_column :slider_images, :company_website 
    add_column :slider_images, :description, :string
  end
end
