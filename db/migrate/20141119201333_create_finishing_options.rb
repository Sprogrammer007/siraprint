class CreateFinishingOptions < ActiveRecord::Migration
  def change
    create_table :finishing_options, :id => false do |t|
      t.references :large_format, index: true
      t.references :large_format_finishing, index: true
    end
  end
end
