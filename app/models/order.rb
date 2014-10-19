class Order < ActiveRecord::Base
  belongs_to :user
  has_many :ordered_products

  def create_order_id
    self.order_id = self.id + 100
  end
end
