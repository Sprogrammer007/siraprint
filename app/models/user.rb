class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :timeout_in => 30.days
  validates :email, format: { with: Broker::VALID_EMAIL_REGEX }

  has_many :delivery_addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  before_create :set_default_state

  scope :approved, -> { where(:status => "Approved") }
  scope :canceled, -> { where(:status => "Canceled") }
  scope :recent, -> (n) { order('created_at DESC').limit(n) }
  
  def new_order(ip)
    order = self.orders.create!(status: 'open', ip_address: ip)
    order.create_order_id
    return order
  end

  def has_order?(id)
    self.orders.where(id: id).any?
  end

  def set_default_state
    self.status = "Approved"
  end

  def has_delivery_addressess?
    delivery_addresses.any?
  end

  def open_order
    orders.where(:status => "open")[0]
  end

  def approvable?
    self.status == "Registered" || self.status == "Disapproved"
  end

  def approved?
    self.status == "Approved"
  end

  def cancelled?
    self.status == "Canceled"
  end
end
