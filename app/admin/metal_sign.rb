ActiveAdmin.register MetalSign do

  menu :parent => "Products"
 
  permit_params :name, :description, :display_image, :status, 
    :metal_sign_sizes_attributes => [:id, :width, :height, :unit, :price, :_destroy, :_destroy => true] 
  
  #Filters
  filter :name
  filter :status
  
  #Scopes
  scope :all, default: true
  scope :active
  scope :deactive

  index :title => "Metal Signs" do
    column :name
    column :description do |m|
      m.description.html_safe() if m.description
    end
    column "status" do |m|
      if m.active?
        status_tag "Active", :ok
      else
        status_tag "Deactive"
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |m|
      item("Manage", admin_metal_sign_path(m))
      item("Edit", edit_admin_metal_sign_path(m))
      item("Copy", copy_admin_metal_sign_path(m))
      item("Remove", admin_metal_sign_path(m), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      item("Active/Deactive", status_update_admin_metal_sign_path(m))
    end
  end

  show do
    div class: "group" do
      div class: "metal-sign-left" do 
        attributes_table do
          row :name
          row "Display Image" do |l|
            image_tag(l.display_image.url(), class: "display-image")
          end
          row :description do |l|
            l.description.html_safe() if l.description
          end
          row "status" do |l|
            if l.active?
              status_tag "Active", :ok
            else
              status_tag "Deactive"
            end
          end
        end
      end
      div class: "metal-sign-right" do 
        panel "Slider Images", class: "group" do
          div class: "slides" do
            if SliderImage.where(product_type: metal_sign.name_for_db).any?
              SliderImage.where(product_type: metal_sign.name_for_db).each do |image|
                render "slider_images/slider_image", slider_image: image
              end
            end
          end
          render "admin/upload_slider", type: metal_sign.name_for_db
        end
      end
    end
    panel "Sizes", class: "group" do
      table_for metal_sign.metal_sign_sizes do
        column :width
        column :height
        column :unit
        column :price
        column "" do |size|
          [
            link_to("Edit", edit_admin_metal_sign_path(size, metal_sign_id: metal_sign.id)),
            link_to("Remove", admin_metal_sign_path(size), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
          ].join(" | ").html_safe
        end
      end
    end
  end

  form :html => {:multipart => true} do |f|
    f.inputs do 
      f.input :name
      f.input :description, input_html: { class: "tinymce" }
      f.input :display_image, :as => :file
      f.input :status, :as => :select, :collection => options_for_select(['Active', 'Deactive'], f.object.status)
    end
    f.inputs do 
      f.has_many :metal_sign_sizes, :allow_destroy => true, :heading => "Sizes", :new_record => true do |s|
        s.input :width
        s.input :height
        s.input :unit, :as => :select, :collection => options_for_select(['inch'], s.object.unit)
        s.input :price
      end
    end
   
    f.actions
  end

  #Actions
  member_action :status_update, method: :get do
    ms = MetalSign.find(params[:id])
    if ms.active?
      ms.update(status: "Deactive")
    else
      ms.update(status: "Active")
    end
    redirect_to :back
  end

  member_action :copy, method: :get do
    ms = MetalSign.find(params[:id])
    ms.clone_with_associations
    redirect_to :back
  end

  controller do
    
    def destroy
      super do |format|
        redirect_to :back and return
      end
    end
  end
end
