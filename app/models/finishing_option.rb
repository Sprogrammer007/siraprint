class FinishingOption < ActiveRecord::Base

  belongs_to :large_format
  belongs_to :large_format_finishing
  self.primary_key = :large_format_id 
end
