
class OrderPdf < Prawn::Document
  def initialize(order, view)
    super(top_margin: 70)
    @order = order
    @view = view
    order_number
    items_table
    sum_table
    questions
  end
  
  def order_number
    text "Sira Print Inc.", size: 15, style: :bold
    text "401 Magnetic Drive, unit 37
          North York, ON M3J 3H9

          info@siraprint.ca 
          416.648.9265"
    move_down 20
    text "Order #: #{@order.order_id}", size: 15, style: :bold, align: :right
  end

  def questions
    move_down 50
    text "Got Questions? Call 41.648.9265, or Email us at info@siraprint.ca", align: :center
  end
  
  def  items_table
    move_down 20
    table item_rows, cell_style: table_style do
      row(0).font_style = :bold
      columns(0).width = 350
      columns(1..3).align = :right
      self.row_colors = ["F8F8F8", "FFFFFF"]
      self.header = true
    end
  end

  def sum_table
    table sum_rows, cell_style: table_style_sum do
      columns(0).width = 350
      columns(1).width = 44
      columns(2).width = 79
      columns(3).width = 67
      columns(3).padding = [5,12,0,0]
      columns(1..3).align = :right
    end
  end

  def item_rows
    [["Product", "Qty", "Unit Price", "Total"]] +
    items = @order.ordered_products.map do |item|
      ["#{item.product.name} - #{item.details.size}", item.quantity, price(item.unit_price), price(item.price)]
    end
  end
  
  def sum_rows
    [["", "", "Sub Total:", price(@order.sub_total)]] +
    [["", "", "Tax:", price(@order.get_tax)]] +
    [["", "", "Grand Total:", price(@order.total)]]
  end
  def price(num)
    @view.number_to_currency(num)
  end


  def table_style
    {
      :border_width => 0,
      :padding => 12
    } 
  end

  def table_style_sum
    {
      :border_width => 0,
    }
  end
end