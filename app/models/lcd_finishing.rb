class LcdFinishing < ActiveRecord::Base

  has_many :lcd_finishing_options
  has_many :lcd, :through => :ldc_finishing_options

  scope :has_none, -> { where(name: "None") }
end
