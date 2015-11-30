class OrderedProduct < ActiveRecord::Base
 
  belongs_to :order

  scope :large_format, -> { where(product_type: "large_format") }
  scope :metal_sign, -> { where(product_type: "metal_sign") }
  scope :plastic_card, -> { where(product_type: "plastic_card") }
  scope :lcd, -> { where(product_type: "lcd") }
  
  before_destroy :remove_details
  def details
    "Ordered#{self.product_type.camelize.gsub("_", "")}Detail".constantize.find(self.product_detail_id)
  end

  def product
    "#{self.product_type.camelize.gsub("_", "")}".constantize.find(self.product_id)
  end

  def create_details(type, details)
    detail = "Ordered#{type.camelize.gsub("_", "")}Detail".constantize.new(details.permit!)
    return detail
  end

  def pro_type
    self.product_type.camelize.split("_").join(" ")
  end

  def price_in_cents
    (self.unit_price*100).round()
  end

  def print_pdf_url 
    urlA =  self.print_pdf.split('/')
    urlA[-1] = CGI.escape( File.basename(self.print_pdf))
    return urlA.join('/')
  end

  def print_pdf_2_url 
    urlA =  self.print_pdf_2.split('/')
    urlA[-1] = CGI.escape( File.basename(self.print_pdf_2))
    return urlA.join('/')
  end

  def remove_details
    unless (self.product_type == 'plastic_card') 
      self.details.destroy
    end
  end

end
