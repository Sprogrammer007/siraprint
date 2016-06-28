class Order < ActiveRecord::Base
  
  attr_accessor :card_number, :card_verification, :final
  after_initialize :init

  STATE = %w{open payed completed canceled}
 
  belongs_to :broker
  belongs_to :user

  has_many :ordered_products, :foreign_key => :order_id, dependent: :destroy
  has_many :transactions, :class_name => "OrderTransaction", dependent: :destroy

  with_options :if => :is_final_step? do |order|
    order.validates :billing_address, presence: true, on: :update
    order.validates :billing_city, presence: true, on: :update
    order.validates :billing_postal, presence: true, on: :update
    order.validates :billing_postal, format: { with: Broker::VALID_POSTAL_CODE_REGEX }, on: :update
    order.validates :name_on_card, presence: true, on: :update
    order.validate :validate_card, on: :update
  end

  scope :open, -> { where(status: "open") }
  scope :canceled, -> { where(status: "canceled") }
  scope :completed, -> { where(status: "completed") }
  scope :payed, -> { where(status: "payed") }
  scope :recent, -> (n) { order('created_at DESC').limit(n) }
  
  def init
    @final = false
  end
  
  def is_final_step?
    @final
  end

  def create_order_id
    self.update(order_id: (self.id + 100))
  end

  delegate :open?, :payed?, :completed?, :canceled?, to: :current_state?

  def current_state?
    status.inquiry
  end

  def sub_total
    read_attribute(:sub_total).to_f
  end

  def update_price
    t = ordered_products.pluck(:price).inject{|sum,x| sum + x }
    self.update(:sub_total => t)
  end

  def get_tax
    if self.sub_total
      ((self.sub_total * 1.13).round(2) - self.sub_total).round(2)
    else
      0
    end
  end

  def total
    if self.sub_total
      (self.sub_total * 1.13).round(2)
    else
      0
    end
  end

  def address
    @address ||= DeliveryAddress.find(self.delivery_id)
  end

  def create_new_ordered_product(params, rate)

    if params[:product_type] == 'metal_sign' &&  !params[:details][:size_id]
      return errors.add(:size, 'please select metal sign size')
    end
    
    unit_price = if (params[:product_type] == 'large_format' || params[:product_type] == 'lcd')
      calc_unit_price(params[:details], rate, params[:quantity].to_i, params[:product_id], params[:product_type])
    elsif params[:product_type] == 'plastic_card'
      plastic_card_unit_price(rate, params[:product_id], params[:quantity].to_i)
    else
      metal_sign_unit_price(rate, params[:details][:size_id], params[:product_id]) 
    end

    unit_price = round(unit_price.to_f)
    total_price = (unit_price.to_f * params[:quantity].to_i)
    if (params[:express]) 
      total_price = (total_price * 1.75)
    end
    # cover to 2 decimal places 
    total_price = ('%.2f' % total_price)
 
    op = self.ordered_products.create(
      quantity: params[:quantity], 
      product_type: params[:product_type],
      # print_pdf: params[:design_pdf], 
      # print_pdf_2: params[:design_pdf_2], 
      product_id: params[:product_id], 
      comment: params[:comment], 
      unit_price: unit_price,
      price: total_price
    )
    return op
  end

  # Validate CC and Add any error to model base messages
  def validate_card
    
    if card_expires_on && credit_card.validate.any?
      credit_card.validate.each do |key, message|
        next if (key == :last_name || key == :first_name)
        errors.add key, message.join()
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :brand              => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
    )
  end

  def purchase
    response = process_purchase
    transactions.create!(:action => "purchase", :amount => total_in_cents, :response => response)
    self.update(status: "payed", :ordered_date => Time.now) if response.success?
    response.success?
  end

  # TO BE REMOVED
  def express_token=(token)
    write_attribute(:express_token, token)
    if !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end

  def prepare_paypal_items
    items = []
    ordered_products.each do |p|
      o = {
            name: p.pro_type,
            description: get_description(p),
            quantity: p.quantity,
            amount: p.price_in_cents
          }
      items << o
    end
       
    return items
  end

  def get_description(p)
    if (p.product_type == "large_format" || p.product_type == 'lcd')
      "Material: #{p.product.name} <br/>
      Thickness: #{p.details.thickness.thickness}#{p.details.thickness.unit} <br/>
      Size: #{p.details.size}".html_safe()
    else
      "Size: #{p.details.size}".html_safe()
    end
  end

  ## END
  def total_in_cents
    (total*100).round()
  end

  def sub_total_in_cents
    (self.sub_total*100).round()
  end 

  def tax_in_cents
    (get_tax*100).round()
  end

  def user!
    return self.user || self.broker
  end
  private
    def process_purchase
      if express_token.blank?
        STANDARD_GATEWAY.purchase(total_in_cents, credit_card, standard_purchase_options)
      else
        EXPRESS_GATEWAY.purchase(total_in_cents, express_purchase_options)
      end
    end

    def express_purchase_options
      {
        :ip         => ip_address,
        :token      => express_token,
        :payer_id   => express_payer_id,
        :currency   => 'CAD'
      }
    end

    def round(num)
      f = ((num*100).round / 100.0)
      return  ('%.2f' % f)
    end

    def standard_purchase_options
      {
        :ip => ip_address,
        :currency   => 'CAD',
        :billing_address => {
          :name     => name_on_card,
          :address1 => billing_address,
          :city     => billing_city,
          :state    => billing_prov,
          :country  => "Canada",
          :zip      => billing_postal
        }
      }
    end

    def calc_sqft(w, l, unit)
      (unit == "inch") ? ((w * l) / 144) : (w * l)
    end

    def get_rate(id, s, side, quantity,type)
      sqft = s
      quantity = quantity.to_i
      if side == 2
        sqft = sqft * 2
      end

      if quantity
        sqft = sqft * quantity
      end
      if type == 'large_format'
        thickness = LargeFormatThickness.find_by_id(id)
        rate = thickness.large_format_tiers.sqft_eq(sqft)
      else
        thickness = LcdThickness.find_by_id(id)
        rate = thickness.lcd_tiers.sqft_eq(sqft)
      end
      return rate.first.price
    end

    def calc_unit_price(details, rate, quantity, id, type)
      width = details[:width].to_f
      length = details[:length].to_f
      if type == 'large_format'
        brokerDiscount = (LargeFormat.find(id).broker_discount).to_f
      else
        brokerDiscount = (Lcd.find(id).broker_discount).to_f
      end
      unit = details [:unit]
      side = details[:side].to_i
      sqft = calc_sqft(width, length, unit).to_f
      rate = (rate || get_rate(details[:thickness_id], sqft, side, quantity, type)) 

      unit_price = (sqft * rate.to_f)
      if self.user!.is_a?(Broker) && brokerDiscount != 0
        unit_price = (unit_price - ((unit_price * brokerDiscount) / 100.0));
      end
    
      if details[:finishing]
        f_price = 0
        s_price = 0
        if details[:finishing].include?('Gloss lamination') || details[:finishing].include?('Matte Lamination') 
          f_price = sqft
        end

        if details[:finishing].include?('Grommets')
          f_price += details[:grommets_quantity].to_i
        end  

        if details[:finishing].include?('Step Sticks')
          s_price = (quantity * 0.80)
          f_price += s_price
        end  

        if details[:finishing].include?('Die Cutting')
          f_price += sqft * 5
        end  

        if details[:finishing].include?('Stretch on Frame')
          f_price += sqft * 3
        end

        unit_price += f_price
      end

      if side == 2
        unit_price = (unit_price * 2) - s_price
      end

      return unit_price.to_f
    end

    def metal_sign_unit_price(price, size, id)
      brokerDiscount = (MetalSign.find(id).broker_discount).to_f
      if self.user!.is_a?(Broker) && brokerDiscount != 0
        price = (price - ((price * brokerDiscount) / 100.0));
      end
      price || MetalSignSize.find_by_id(size).price           
    end    

    def plastic_card_unit_price(rate, id, q)
      plastic_card = PlasticCard.find(id);
      rate = (rate || plastic_card.plastic_card_prices.rate(q).first.rate).to_f
      brokerDiscount = (plastic_card.broker_discount).to_f
      if self.user!.is_a?(Broker) && brokerDiscount != 0
        rate = (rate - ((rate * brokerDiscount) / 100.0));
      end
      rate  
    end

end
