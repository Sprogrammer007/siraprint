class CreateOrderedProducts < ActiveRecord::Migration
  def change
    create_table :ordered_products do |t|

      t.timestamps
    end
  end
end
