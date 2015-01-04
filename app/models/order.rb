class Order < ActiveRecord::Base
  
  STATE = %w{open payed completed canceled}
  belongs_to :user
  has_many :ordered_products, :foreign_key => :order_id
  has_many :transactions, :class_name => "OrderTransaction"

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

  def create_new_ordered_product(params)
    op = self.ordered_products.create(
      quantity: params[:quantity], 
      product_type: params[:product_type],
      print_pdf: params[:design_pdf], 
      print_pdf_2: params[:design_pdf_2], 
      product_id: params[:product_id], 
      unit_price: params[:unit_price],
      price: params[:total_price]
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
end
