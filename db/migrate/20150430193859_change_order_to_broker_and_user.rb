class ChangeOrderToBrokerAndUser < ActiveRecord::Migration
  def change
    rename_column :orders, :user_id, :broker_id
    add_column :orders, :user_id, :integer
    
    rename_column :delivery_addresses, :user_id, :broker_id
    add_column :delivery_addresses, :user_id, :integer
  end
end
