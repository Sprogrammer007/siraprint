class PlasticCardPrice < ActiveRecord::Base

  belongs_to :plastic_card 
  scope :rate, -> (q) { where("min <= :q AND max >= :q", { :q => q }) }
end
