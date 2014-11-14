class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.references :user
    	t.string :order_id
    	t.integer :delivery_id
        t.text :delivery_address
    	t.decimal :sub_total

    	t.string :status
    	t.timestamps
    end
  end
end
