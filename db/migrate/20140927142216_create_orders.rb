class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.references :user
    	t.string :order_id
    	t.string :delivery_method

    	t.decimal :sub_total
    	t.decimal :total

    	t.string :status
    	t.timestamps
    end
  end
end
