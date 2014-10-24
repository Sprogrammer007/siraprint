class OrderedLargePrintDetail < ActiveRecord::Base

  def material
    LargePrintMaterial.find(self.material_id)
  end

  def sqft
    if self.unit == "inch"
      ((self.width * self.length) / 144.0).round(2)
    else
      (self.width * self.length)
    end
  end

  def thickness
    MaterialThickness.find(self.thickness_id)
  end
end
