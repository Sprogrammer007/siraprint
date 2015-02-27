class AddCreditCardToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :name_on_card, :string 
    add_column :orders, :card_type, :string 
    add_column :orders, :card_expires_on, :date 
    add_column :orders, :billing_address, :string 
    add_column :orders, :billing_prov, :string 
    add_column :orders, :billing_city, :string 
    add_column :orders, :billing_postal, :string 
    remove_column :orders, :express_payer_id, :string
    remove_column :orders, :express_token, :string
  end
end
