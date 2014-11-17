class Order < ActiveRecord::Base
  
  STATE = %w{open payed completed canceled}
  belongs_to :user
  has_many :ordered_products, :foreign_key => :order_id

  scope :open, -> { where(status: "open") }
  scope :canceled, -> { where(status: "canceled") }
  scope :completed, -> { where(status: "completed") }
  scope :payed, -> { where(status: "payed") }
  scope :recent, -> (n) { order('created_at DESC').limit(n) }
  before_save :create_order_id
  
  def create_order_id
    self.order_id = self.id + 100
  end

  delegate :open?, :payed?, :completed?, :canceled?, to: :current_state?

  def current_state?
    status.inquiry
  end

  def update_price
    t = ordered_products.pluck(:price).inject{|sum,x| sum + x }
    self.update(:sub_total => t)
  end

  def get_tax
    ((self.sub_total * 1.13) - self.sub_total).round(2)
  end

  def total
    (self.sub_total * 1.13).round(2)
  end

  def address
    @address ||= DeliveryAddress.find(self.delivery_id)
  end
end
