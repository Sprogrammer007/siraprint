class AddHasTwoSidedToLargeFormat < ActiveRecord::Migration
  def change
     add_column :large_formats, :has_two_side, :boolean
  end
end
