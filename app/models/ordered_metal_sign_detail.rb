class OrderedMetalSignDetail < ActiveRecord::Base
  validates :size_id, presence: true
  
  def size
    size = MetalSignSize.find(self.size_id)
    "#{size.width}\" x #{size.height}\""
  end
end
