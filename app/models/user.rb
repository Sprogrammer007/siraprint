class User < ActiveRecord::Base

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_POSTAL_CODE_REGEX = /\A([A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9])\z/i
 	VALID_PHONE_REGEX = /\A\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\z/i
  VALID_HST_REGEX = /\A(\d{9})\z/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # validates :company_name, :company_province, :company_address,:company_postal,
  # :company_phone, :company_hst, :company_city, presence: true
  # validates :email, format: { with: VALID_EMAIL_REGEX }
  # validates :company_postal, format: { with: VALID_POSTAL_CODE_REGEX }
  # validates :company_phone, format: { with: VALID_PHONE_REGEX }
  # validates :company_hst, format: { with: VALID_HST_REGEX }

  has_many :delivery_addresses
  has_many :orders
  before_create :set_default_state

  scope :approved, -> { where(:status => "Approved") }
  scope :recent, -> (n) { order('created_at DESC').limit(n) }
  
  def new_order
    order = self.orders.create!(status: 'open')
    order.create_order_id
    return order
  end

  def set_default_state
    self.status = "Registered"
  end

  def has_delivery_addressess?
    delivery_addresses.any?
  end

  def open_order
    orders.where(:status => "open")[0]
  end


  def self.provinces
  	%w{Ontario Quebec Nova\ Scotia New\ Brunswick Manitoba British\ Columbia Alberta}
  end

  def approvable?
    self.status == "Registered" || self.status == "Disapproved"
  end

  def approved?
    self.status == "Approved"
  end

end
