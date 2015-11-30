class LcdThickness < ActiveRecord::Base

  belongs_to :lcd
  has_many :lcd_tiers, :dependent => :destroy

  accepts_nested_attributes_for :lcd_tiers, :allow_destroy => true

end
