ActiveAdmin.register Order do
  config.clear_action_items!
  menu :parent => "Adminstration"

  #Scopes
  scope :all, default: true
  scope :open
  scope :canceled
  scope :completed
  scope :payed

  #filters
  filter :user, :collection => -> { User.all.map { |u| [u.email, u.id] } }
  filter :sub_total
  filter :created_at
  filter :updated_at
  
  index :title => "Orders" do
    column "User Email" do |o|
      o.user.email
    end
    column "Delivery Address" do |o|
      o.delivery_address.html_safe() if o.delivery_address
    end
    column "Order Sub-Total" do |o|
      if o.sub_total
        "$#{o.sub_total}"
      else
        "$0"
      end
    end
    column "Order Tax" do |o|
      "$#{o.get_tax}"
    end
    column "Order Total" do |o|
      "$#{o.total}"
    end

    column "Status" do |o|
      case o.status
      when "open", "payed"
        status_tag o.status.camelize, nil, class: "open"
      when "delivered", "completed"
        status_tag o.status.camelize, :ok
      else "canceled"
        status_tag o.status.camelize, nil, class: "cancel"
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |o|
      item("Order Details", admin_order_path(o))
      item("Remove Order", admin_order_path(o), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      item("Mark as Complete", complete_admin_order_path(o))
    end
  end

  show do
    div class: "group" do
      div class: "order-main" do
        attributes_table do
          row "User Email" do |o|
            o.user.email
          end
          row "Delivery Address" do |o|
            o.delivery_address.html_safe() if o.delivery_address
          end
          row "Order Sub-Total" do |o|
            if o.sub_total
              "$#{o.sub_total}"
            else
              "$0"
            end
          end
          row  "Order Tax" do |o|
            "$#{o.get_tax}"
          end
          row "Order Total" do |o|
            "$#{o.total}"
          end
          row "Status" do |o|
            case o.status
            when "open", "payed"
              status_tag o.status.camelize, nil, class: "open"
            when "delivered", "completed"
              status_tag o.status.camelize, :ok
            else "canceled"
              status_tag o.status.camelizes, nil, class: "cancel"
            end
          end
        end
      end
    end
    div class: "item-list" do
      panel("Items", class: "group") do
        if order.ordered_products.large_format  
          .any?
          h2 "Large Formats"
          table_for order.ordered_products.large_format do
            column "Product" do |p|
              image_tag p.product.display_image.url()
            end
            column "Material Name" do |p|
              link_to p.product.name, admin_large_format_path(p.product)
            end
            column "Side" do |p|
              "#{p.details.side}"
            end
            column "Thickness" do |p|
              "#{p.details.thickness.thickness}#{p.details.thickness.unit}"
            end
            column "Width" do |p|
              "#{p.details.width}#{p.details.unit}"
            end
            column "Length" do |p|
              "#{p.details.length}#{p.details.unit}"
            end
            column "Sqft" do |p|
              "#{p.details.size}"
            end
            column :quantity
            column "User Design" do |p|
              link_to p.print_pdf_file_name, p.print_pdf.url()
            end
            column "User Design 2" do |p|
              if p.print_pdf_2_file_name
                link_to p.print_pdf_2_file_name, p.print_pdf_2.url()
              else
                "None"
              end
            end
            column "Finishing" do |p|
              if p.details.finishing == ''
                "None"
              else
                p.details.finishing.join(' | ')
              end
            end
            column "Gromments #" do |p|
              "#{p.details.grommets_quantity || 0}" 
            end
            column :unit_price
            column :price
            column "" do |p|
              link_to("Remove", admin_ordered_product_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
            end
          end
        end
        if order.ordered_products.metal_sign.any?
          h2 "Metal Signs"
          table_for order.ordered_products.metal_sign do
            column "Product" do |p|
              image_tag p.product.display_image.url()
            end
            column "Product Name" do |p|
              link_to p.product.name, admin_metal_sign_path(p)
            end
            column "Size" do |p|
              "#{p.details.size}"
            end
            column :quantity
            column "User Design" do |p|
              link_to p.print_pdf_file_name, p.print_pdf.url()
            end
            column :unit_price
            column :price
            column "" do |p|
              link_to("Remove", admin_ordered_product_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
            end
          end
        end
      end
    end
  end

  #Actions
  member_action :complete, method: :get do
    order = Order.find(params[:id])
    if order.payed?
      order.update(status: "completed")
    end
    redirect_to :back
  end

end