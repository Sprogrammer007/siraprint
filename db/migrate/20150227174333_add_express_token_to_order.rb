class AddExpressTokenToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :express_payer_id, :string
    add_column :orders, :express_token, :string
  end
end
