ActiveAdmin.register AdminUser do
  
  menu :parent => "Adminstration"

  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column "" do |u|
      dropdown_menu "Actions" do 
        item("View Admin Details", admin_admin_user_path(u))
        item("Edit Admin", edit_admin_admin_user_path(u))
        item("Delete Admin", admin_admin_user_path(u), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      end
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
