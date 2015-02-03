class AddMaxSizeToLargeFormat < ActiveRecord::Migration
  def change
    add_column :large_formats, :max_width, :decimal
    add_column :large_formats, :max_length, :decimal
  end
end
