class Order < ActiveRecord::Base
  
  STATE = %w{open payed completed canceled}
  belongs_to :user
  has_many :ordered_products, :foreign_key => :order_id, dependent: :destroy
  has_many :transactions, :class_name => "OrderTransaction", dependent: :destroy

  scope :open, -> { where(status: "open") }
  scope :canceled, -> { where(status: "canceled") }
  scope :completed, -> { where(status: "completed") }
  scope :payed, -> { where(status: "payed") }
  scope :recent, -> (n) { order('created_at DESC').limit(n) }
  
  def create_order_id
    self.update(order_id: (self.id + 100))
  end

  delegate :open?, :payed?, :completed?, :canceled?, to: :current_state?

  def current_state?
    status.inquiry
  end

  def sub_total
    round(read_attribute(:sub_total))
  end

  def update_price
    t = ordered_products.pluck(:price).inject{|sum,x| sum + x }
    self.update(:sub_total => t)
  end

  def get_tax
    if self.sub_total
      round((self.sub_total * 1.13) - self.sub_total)
    else
      0
    end
  end

  def total
    if self.sub_total
      round((self.sub_total * 1.13))
    else
      0
    end
  end

  def address
    @address ||= DeliveryAddress.find(self.delivery_id)
  end

  def create_new_ordered_product(params, rate)

    unit_price = if params[:product_type] == 'large_format'
      calc_unit_price(params[:details], rate, params[:quantity].to_i)
    else
      metal_sign_unit_price(rate, params[:details][:size_id]) 
    end

    total_price = (unit_price.to_f * params[:quantity].to_i)
    
    unit_price = round(unit_price.to_f)
    total_price = round(total_price.to_f)

    op = self.ordered_products.create(
      quantity: params[:quantity], 
      product_type: params[:product_type],
      print_pdf: params[:design_pdf], 
      print_pdf_2: params[:design_pdf_2], 
      product_id: params[:product_id], 
      unit_price: unit_price,
      price: total_price
    )
    return op
  end

  def purchase
    response = process_purchase
    transactions.create!(:action => "purchase", :amount => total_in_cents, :response => response)
    self.update(status: "payed") if response.success?
    response.success?
  end
  
  def express_token=(token)
    write_attribute(:express_token, token)
    if !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end


  def total_in_cents
    (total*100).round()
  end

  def sub_total_in_cents
    (self.sub_total*100).round()
  end 

  def tax_in_cents
    (get_tax*100).round()
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
    if p.product_type == "large_format"
      "Material: #{p.product.name} <br/>
      Thickness: #{p.details.thickness.thickness}#{p.details.thickness.unit} <br/>
      Size: #{p.details.size}".html_safe()
    else
      "Size: #{p.details.size}".html_safe()
    end
  end


  private

    def round(num)
      ((num*100).round / 100.0)
    end
    def process_purchase
      if express_token.blank?
        STANDARD_GATEWAY.purchase(total_in_cents, credit_card, standard_purchase_options)
      else
        EXPRESS_GATEWAY.purchase(total_in_cents, express_purchase_options)
      end
    end

    def standard_purchase_options
      {
        :ip => ip_address,
        :billing_address => {
          :name     => "",
          :address1 => "",
          :city     => "",
          :state    => "",
          :country  => "",
          :zip      => ""
        }
      }
    end

    def express_purchase_options
      {
        :ip         => ip_address,
        :token      => express_token,
        :payer_id   => express_payer_id,
        :currency   => 'CAD'
      }
    end

    def calc_sqft(w, l, unit)
      (unit == "inch") ? ((w * l) / 144) : (w * l)
    end

    def get_rate(id, s, side, quantity)
      sqft = s
      quantity = quantity.to_i
      if side == 2
        sqft = sqft * 2
      end

      if quantity
        sqft = sqft * quantity
      end

      thickness = LargeFormatThickness.find_by_id(id)
      rate = thickness.large_format_tiers.sqft_eq(sqft)
      return rate.first.price
    end

    def calc_unit_price(details, rate, quantity)
      width = details[:width].to_f.round(2)
      length = details[:length].to_f.round(2)
      unit = details [:unit]
      side = details[:side].to_i
      sqft = calc_sqft(width, length, unit).to_f.round(2)
      rate = (rate || get_rate(details[:thickness_id], sqft, side, quantity)) 

      unit_price = (sqft * rate.to_f.round(2))

      if details[:finishing]
        f_price = 0
        if details[:finishing].include?('Gloss lamination') || details[:finishing].include?('Matte Lamination') 
          f_price = sqft
        end
        if details[:finishing].include?('Grommets')
          f_price += details[:grommets_quantity].to_i
        end
        unit_price += f_price
      end

      if side == 2
        unit_price = unit_price * 2
      end

      return unit_price.to_f
    end

    def metal_sign_unit_price(price, size)
      price || MetalSignSize.find_by_id(size).price           
    end

end
