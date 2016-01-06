ActiveAdmin.register Lcd, as: 'LED' do
  
	menu :parent => "Products", :label => "LED Panels"
	
  permit_params :name, :description, :broker_discount, :display_image_file_name, :has_two_side, :status, :max_width, :max_length,
    :lcd_thicknesses_attributes => [:id, :thickness, :unit, :_destroy, :_destroy => true,
    :lcd_tiers_attributes => [:id, :level, :min_sqft, :max_sqft, :price, :_destroy => true ] ] 
  
  # action_item :add_finishing, :only => :show do
  #   link_to("Add Finishing Options", add_finishing_admin_lcd_path(lcd))
  # end

  #Filters
  filter :name
  filter :status

  #Scopes
  scope :all, default: true
  scope :active
  scope :deactive

  index :title => "LED Displays & LGP" do
    column "Material Name" do |l|
      l.name
    end
    column :description do |l|
      l.description.html_safe() if l.description
    end
    column :max_width
    column :max_length
    column :broker_discount do |l|
      "#{l.broker_discount}%"
    end
    column "Has Two Sided?" do |l|
      if l.has_two_side
        status_tag "Yes", :ok
      else
        status_tag "No", :ok
      end
    end
    column "status" do |l|
      if l.active?
        status_tag "Active", :ok
      else
        status_tag "Deactive"
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |l|
			item("Manage", admin_led_path(l))
      item("Edit", edit_admin_led_path(l))
      item("Duplicate", copy_admin_led_path(l))
      item("Remove", admin_led_path(l), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
			item("Active/Deactive", status_update_admin_led_path(l))
      # item("Select Finishing Options", add_finishing_admin_lcd_path(l))
    end
  end

  show do
    div class: "group" do
      div class: "large-format-left" do 
        attributes_table do
          row "Material Name" do |l|
            l.name
          end
          row "Display Image" do |l|
            image_tag(l.display_image_file_name.url(), class: "display-image")
          end
          row :description do |l|
            l.description.html_safe() if l.description
          end
          row :max_width
          row :max_length
          row :broker_discount do |l|
            "#{l.broker_discount}%"
          end
          row "Has Two Sided?" do |l|
            if l.has_two_side
              status_tag "Yes", :ok
            else
              status_tag "No", :ok
            end
          end
          row "Finishing Options" do |l|
            if l.lcd_finishings.any?
              [l.lcd_finishings.map { |f| f.name } ].join(" | ")
            end
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
      div class: "large-format-right" do 
        panel "Slider Images", class: "group" do
          div class: "slides" do
            if SliderImage.where(product_type: led.name_for_db).any?
              SliderImage.where(product_type: led.name_for_db).each do |image|
                render "slider_images/slider_image", slider_image: image
              end
            end
          end
          render "admin/upload_slider", type: led.name_for_db

        end

        panel "Finishing Options", class: "group" do
					render "admin/add_lcd_finishing", finishings: LcdFinishing.all, selected: led.lcd_finishings.pluck(:id)
      
        end
      
      end
    end
    panel "Thicknesses", class: "group" do
      led.lcd_thicknesses.each do |t|
        div class: "thickness-set" do
          attributes_table_for t do
            row :thickness
            row :unit
            row " " do |thickness|
              [
								link_to("Edit", edit_admin_led_thickness_path(thickness, lcd_id: led.id)),
								link_to("Remove", admin_led_thickness_path(thickness), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
              ].join(" | ").html_safe
            end
          end

          table_for t.lcd_tiers do
            column :level
            column :min_sqft
            column :max_sqft
            column :price
            column "" do |tier|
              [
								link_to("Edit", edit_admin_led_tier_path(tier,lcd_id: led.id, lcd_thickness_id: tier.lcd_thickness_id )),
								link_to("Remove", admin_led_tier_path(tier), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
              ].join(" | ").html_safe
            end
          end
					text_node link_to "Add Tier", new_admin_led_tier_path(lcd_id: led.id, lcd_thickness_id: t.id), class: "link_button right"
        end
      end
			text_node link_to "Add Thickness", new_admin_led_thickness_path(lcd_id: led.id), class: "link_button add-thickness"
    end
  end

  form :html => {:multipart => true} do |f|
    f.inputs do 
      f.input :name, label: "Material Name"
      f.input :description, input_html: { class: "tinymce" }
      f.input :display_image_file_name, :as => :file
      f.input :broker_discount, label: "Broker Discount(in %)"
      f.input :max_width, label: "Max Width(Inchs)"
      f.input :max_length, label: "Max Length(Inchs)"
      f.input :has_two_side, :as => :select, :collection => options_for_select([["Yes", true], ["No", false]], (f.object.has_two_side || false))
      f.input :status, :as => :select, :collection => options_for_select(['Active', 'Deactive'], f.object.status)
    end

    f.has_many :lcd_thicknesses, :allow_destroy => true, :heading => false, :new_record => true do |t|
      t.input :thickness
      t.input :unit, :as => :select, :collection => options_for_select(['cm', 'mm', 'pt', 'mil', 'inch'], t.object.unit)
    
      t.has_many :lcd_tiers, :allow_destroy => true, :heading => false, :new_record => true, class: "tier-sets group" do |tier|
        tier.input :level
        tier.input :min_sqft
        tier.input :max_sqft
        tier.input :price
      end
      
    end
  	if f.object.new_record?
			f.actions do
				f.action(:submit, :label => "Create Led")
			end
		else 
			f.actions do
				f.action(:submit, :label => "Update Led")
			end
		end
  end

  #Actions
  member_action :status_update, method: :get do
    lcd = Lcd.find(params[:id])
    if lcd.active?
      lcd.update(status: "Deactive")
    else
      lcd.update(status: "Active")
    end
    redirect_to :back
  end

  member_action :copy, method: :get do
    lcd = Lcd.find(params[:id])
    lcd.clone_with_associations
    redirect_to :back
  end

  # member_action :add_finishing, method: :get do
  #   @page_title = "Select Regions For #{params[:name]}"
  #   lg = LargeFormat.find(params[:id])
  #   @finishings = LargeFormatFinishing.all
  #   @selected_finishings = lg.lcd_finishings.pluck(:id)
  #   render template: "admin/add_finishing"
  # end

  member_action :remove_finishing, method: :delete do
    LcdFinishingOption.where("lcd_id = ? AND lcd_finishing_id = ?", params[:id], params[:lcd_finishing_id]).delete_all

    flash[:notice] = "Finishing option was successfully removed!"
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
