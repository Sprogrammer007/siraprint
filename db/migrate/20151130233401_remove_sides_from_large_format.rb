class RemoveSidesFromLargeFormat < ActiveRecord::Migration
  def change
    remove_column :large_formats, :sides, :integer
  end
end
