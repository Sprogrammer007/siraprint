ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "New Users" do
          table_for User.recent(5) do
            column :email
            column :company_name
            column :company_hst
            column :last_sign_in_at
            column "Joined At" do |u|
              u.created_at.strftime("%m-%d-%Y")
            end
            column "Status" do |u|
              if u.status == "Approved"
                status_tag "Approved",:ok
              elsif u.status == "Disapproved"
                status_tag "Disapproved", :error
              else
                status_tag "#{u.status}"
              end 
            end
          end
        end
      end

      column do
        panel "New Orders" do
          table_for Order.recent(5) do
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
          end
        end
      end
    end
  end # content
end
