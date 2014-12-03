class AddExpressToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_method, :string
    add_column :orders, :express_payer_id, :string
    add_column :orders, :express_token, :string
    add_column :orders, :ip_address, :string
  end
end
