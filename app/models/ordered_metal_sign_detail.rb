class OrderedMetalSignDetail < ActiveRecord::Base
  validates :size_id, presence: true
  
  def size
    MetalSignSize.find(self.size_id)
  end
end
