class AddStickToLargeFormat < ActiveRecord::Migration
  def change
    add_column :ordered_large_format_details, :sticks_quantity, :integer, default: 0
  end
end
