class PlasticCard < ActiveRecord::Base

  has_many :plastic_card_prices, :dependent => :destroy

  scope :active, -> { where(status: "Active") }
  scope :deactive, -> { where(status: "Deactive") }

  mount_uploader :display_image_file_name, PlasticCardDisplayUploader
  validates_presence_of :display_image_file_name 
  accepts_nested_attributes_for :plastic_card_prices
  
  delegate :active?, :deactive?, to: :current_state?

  def name_for_db
    if self.name
      self.name.downcase.split(" ").join("_")
    end
  end

  def update_unite_price(q, user)
    rate = self.plastic_card_prices.rate(q).first.rate
    brokerDiscount = (self.broker_discount).to_f
    if user.is_a?(Broker) && brokerDiscount != 0
      rate = (rate - ((rate * brokerDiscount) / 100.0));
    end
    rate
  end
  
  def current_state?
    status.downcase.inquiry
  end

  def clone_with_associations
    new_record = self.dup
    new_record.save
    #sizes
    if self.plastic_card_prices.any?
      self.plastic_card_prices.each do |price|
        new_price = price.dup
        new_price.save
        new_price.update(:plastic_card_id => new_record.id)
      end
    end
    new_record
  end
end