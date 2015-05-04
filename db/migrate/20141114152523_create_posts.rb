class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :excerpt
      t.text :content
      t.string :author
      t.string :category
      t.string :featured_image_file_name
      t.timestamps
    end
  end
end
