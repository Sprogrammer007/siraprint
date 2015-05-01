class ChangeUserToBroker < ActiveRecord::Migration
  def change
    rename_table :users, :brokers
  end 
end
