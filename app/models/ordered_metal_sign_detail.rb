class OrderedMetalSignDetail < ActiveRecord::Base
  def size
    MetalSignSize.find(self.size_id)
  end
end
