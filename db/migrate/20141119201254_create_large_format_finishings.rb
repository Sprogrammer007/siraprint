class CreateLargeFormatFinishings < ActiveRecord::Migration
  def change
    create_table :large_format_finishings do |t|
      t.string :name
    end
  end
end
