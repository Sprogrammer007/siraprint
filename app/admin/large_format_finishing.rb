ActiveAdmin.register LargeFormatFinishing do

  menu :parent => "Global"

  permit_params :name
  
  #Filters
  filter :name

  index :title => "Large Formats Finishing Options" do
    column :id
    column :name
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |f|
      item("Edit", edit_admin_large_format_finishing_path(f))
      item("Remove", admin_large_format_finishing_path(f), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
    end
  end

  form do |f|
    f.inputs do
      f.input :large_format_id, :as => :hidden, :input_html => { value: "#{params[:large_format_id] }"}
      f.input :name
    end
    f.actions
  end

  controller do
    def create

      super do |format|
        redirect_to admin_large_formats_path()
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_large_formats_path()
        return
      end
    end

    def destroy
      super do |format|
        redirect_to :back and return
      end
    end
  end

end