class AddCommentToOrder < ActiveRecord::Migration
  def change
    add_column :ordered_products, :comment, :string 
  end
end
