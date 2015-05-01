class AddBrokerDiscount < ActiveRecord::Migration
  def change
    add_column :large_formats, :broker_discount, :integer, default: 0
    add_column :metal_signs, :broker_discount, :integer, default: 0
  end
end
