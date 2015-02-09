class AddOrderedDateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ordered_date, :datetime 
  end
end
