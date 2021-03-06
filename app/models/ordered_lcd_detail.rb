class OrderedLcdDetail < ActiveRecord::Base
  validates :length, :width, :thickness_id,:unit, :side, presence: true
  serialize :finishing
  def size
    if self.unit == "inch"
      size = ((self.width * self.length) / 144.0).round(2)
    else
      size = (self.width * self.length)
    end
    "#{size}sqft"
  end

  def thickness
    LcdThickness.find(self.thickness_id)
  end
end