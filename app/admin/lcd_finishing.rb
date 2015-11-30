ActiveAdmin.register LcdFinishing do

  menu :parent => "Global"

  permit_params :name
  
  #Filters
  filter :name

  index :title => "Lcd Finishing Options" do
    column :id
    column :name
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |f|
      item("Edit", edit_admin_lcd_finishing_path(f))
      item("Remove", admin_lcd_finishing_path(f), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
    end
  end

  form do |f|
    f.inputs do
      f.input :lcd_id, :as => :hidden, :input_html => { value: "#{params[:lcd_id] }"}
      f.input :name
    end
    f.actions
  end

  controller do
    def create

      super do |format|
        redirect_to admin_lcd_finishings_path()
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_lcd_finishings_path()
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