class CreateSliderImages < ActiveRecord::Migration
  def change
    create_table :slider_images do |t|

      t.attachment :slide_image
      t.string :product_type
      t.timestamps
    end
  end
end
