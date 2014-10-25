class CreateDeliveryAddresses < ActiveRecord::Migration
  def change
    create_table :delivery_addresses do |t|
    	t.references :user
    	t.string :full_name
      t.string :address
      t.string :province
      t.string :city
      t.string :postal

      t.timestamps
    end
  end
end
