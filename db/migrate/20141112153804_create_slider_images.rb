class CreateSliderImages < ActiveRecord::Migration
  def change
    create_table :slider_images do |t|

      t.string :slide_imagestring
      t.string :product_type
      t.timestamps
    end
  end
end
