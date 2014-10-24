ActiveAdmin.register Order do
  menu :parent => "Adminstration"

  #Scopes
  scope :all, default: true
  scope :open

  index :title => "Orders" do
    column "User Email" do |o|
      o.user.email
    end
    column :delivery_method
    column "Order Sub-Total" do |o|
      "$#{o.sub_total}"
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
        status_tag o.status.camelizes, nil, class: "cancel"
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |o|
      item("Order Details", admin_order_path(o))
      item("Edit Product", edit_admin_order_path(o))
      item("Remove Order", admin_order_path(o), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      item("Mark as Complete", "#")
    end
  end

  show do
    div class: "group" do
      div class: "order-main" do
        attributes_table do
          row "User Email" do |o|
            o.user.email
          end
          row :delivery_method
          row :"Order Sub-Total" do |o|
            "$#{o.sub_total}"
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
      panel("Items", class: "group")do
      end
    end
  end
end