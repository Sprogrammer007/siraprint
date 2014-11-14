class OrderedLargeFormatDetail < ActiveRecord::Base

  def sqft
    if self.unit == "inch"
      ((self.width * self.length) / 144.0).round(2)
    else
      (self.width * self.length)
    end
  end

  def thickness
    LargeFormatThickness.find(self.thickness_id)
  end
end
