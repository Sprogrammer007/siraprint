class AddExpressToOrderedProducts < ActiveRecord::Migration
  def change
    add_column :ordered_products, :express, :boolean 
  end
end
