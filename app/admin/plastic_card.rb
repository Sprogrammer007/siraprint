ActiveAdmin.register PlasticCard do

  menu :parent => "Products"
 
  permit_params :name, :description, :display_image_file_name, :broker_discount, :status, 
    :meta_description, :page_title,  
    :plastic_card_prices_attributes => [:id, :min, :max, :rate, :_destroy, :_destroy => true] 
  
  #Filters
  filter :name
  filter :status
  
  #Scopes
  scope :all, default: true
  scope :active
  scope :deactive

  index :title => "Plastic Cards" do
    column :name

    column :broker_discount do |p|
      "#{p.broker_discount}%"
    end
    column :description do |p|
      p.description.html_safe() if p.description
    end
    column "status" do |p|
      if p.active?
        status_tag "Active", :ok
      else
        status_tag "Deactive"
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |p|
      item("Manage", admin_plastic_card_path(p))
      item("Edit", edit_admin_plastic_card_path(p))
      item("Copy", copy_admin_plastic_card_path(p))
      item("Remove", admin_plastic_card_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      item("Active/Deactive", status_update_admin_plastic_card_path(p))
    end
  end

  show do
    div class: "group" do
      div class: "metal-sign-left" do 
        attributes_table do
          row :name
          row "Display Image" do |p|
            image_tag(p.display_image_file_name.url(), class: "display-image")
          end
          row :broker_discount do |p|
            "#{p.broker_discount}%"
          end
          row :description do |p|
            p.description.html_safe() if p.description
          end
          row "Video" do |l|
            if l.has_video?
              render "admin/video", video: l.video
            end
          end
          row "status" do |p|
            if p.active?
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
            if SliderImage.where(product_type: plastic_card.name_for_db).any?
              SliderImage.where(product_type: plastic_card.name_for_db).each do |image|
                render "slider_images/slider_image", slider_image: image
              end
            end
          end
          render "admin/upload_slider", type: plastic_card.name_for_db
        end
      end
    end
    panel "Prices", class: "group" do
      table_for plastic_card.plastic_card_prices do
        column :min, as: 'Min Quantity'
        column :max, as: 'Max Quantity'
        column :rate
        column "" do |rate|
          [
            link_to("Edit", edit_admin_plastic_card_price_path(rate, plastic_card_id: plastic_card.id)),
            link_to("Remove", admin_plastic_card_price_path(rate), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
          ].join(" | ").html_safe
        end
      end
    end
  end

  form :html => {:multipart => true} do |f|
    f.inputs do 
      f.input :name
      f.input :description, input_html: { class: "tinymce" }
      f.input :video, label: "Youtube Video"
      f.input :broker_discount, label: "Broker Discount(in %)"
      f.input :display_image_file_name, :as => :file
      f.input :status, :as => :select, :collection => options_for_select(['Active', 'Deactive'], f.object.status)
      f.input :page_title, label: "Page Tital"
      f.input :meta_description, label: "Meta Description", :as => :text
    end
    f.inputs do 
      f.has_many :plastic_card_prices, :allow_destroy => true, :heading => "Prices", :new_record => true do |s|
        s.input :min, label: 'Min Quantity'
        s.input :max, label: 'Max Quantity'
        s.input :rate
      end
    end
    f.actions
  end

  #Actions
  member_action :status_update, method: :get do
    pc = PlasticCard.find(params[:id])
    if pc.active?
      pc.update(status: "Deactive")
    else
      pc.update(status: "Active")
    end
    redirect_to :back
  end

  member_action :copy, method: :get do
    pc = PlasticCard.find(params[:id])
    pc.clone_with_associations
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
