class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :excerpt
      t.text :content
      t.string :author
      t.string :category
      t.attachment :featured_image
      t.timestamps
    end
  end
end
