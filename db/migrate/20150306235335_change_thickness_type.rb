class ChangeThicknessType < ActiveRecord::Migration
  def change
    change_column :large_format_thicknesses, :thickness, :decimal
  end
end
