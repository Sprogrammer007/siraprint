class LcdFinishingOption < ActiveRecord::Base

  belongs_to :lcd
  belongs_to :lcd_finishing
  self.primary_key = :lcd_id 
end
