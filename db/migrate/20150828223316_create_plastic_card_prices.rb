class CreatePlasticCardPrices < ActiveRecord::Migration
  def change
    create_table :plastic_card_prices do |t|
      t.references :plastic_card
      t.integer :min
      t.integer :max
      t.decimal :rate, precision: 30, scale: 2
    end
  end
end
