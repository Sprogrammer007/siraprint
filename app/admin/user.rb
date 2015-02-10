ActiveAdmin.register User do

  menu :parent => "Adminstration"
 
  permit_params :email, :password, :status, :company_name, :company_address,
   :company_province, :company_city, :company_postal, :company_hst, :company_phone
   
  #Scopes
  scope :all, default: true
  scope :approved

  #Filters
  filter :email
  filter :company_name
  filter :company_hst
  filter :created_at


  #Index Table
  index do
    column :id
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
    column "" do |u|
      dropdown_menu "Actions" do 
        item("View User Details", admin_user_path(u))
        item("Edit User", edit_admin_user_path(u))
        item("Delete User", admin_user_path(u), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
        item("Approve User", approve_admin_user_path(u))     
        item("Disapprove User", disapprove_admin_user_path(u))     
      end
    end
  end


  form do |f|
    f.inputs do 
      f.input :email
      f.input :password, :as => :string
      f.input :status, :as => :select, :collection => options_for_select(['Registered', 'Approved', "Disapproved"], f.object.status)
      f.input :company_name
      f.input :company_address
      f.input :company_province, :as => :select, :collection => options_for_select(User.provinces, f.object.company_province)
      f.input :company_city
      f.input :company_postal
      f.input :company_phone
      f.input :company_hst
    end
    f.actions
  end

  #Actions
  member_action :approve, method: :get do
    @user = User.find(params[:id])
    if @user.approvable?
      UserMailer.user_approved(@user).deliver
      @user.update(status: "Approved")
    else
      @user.update(status: "Disapproved")
    end
    redirect_to :back
  end

  member_action :disapprove, method: :get do
    @user = User.find(params[:id])
    @user.update(status: "Disapproved")
 
    redirect_to :back
  end

end
