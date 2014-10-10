ActiveAdmin.register LargePrint do

  menu :parent => "Products"

  permit_params :name, :description, :display_image, :sides, :status
  
  #Filters
  filter :name
  filter :sides
  filter :status


  index :title => "Large Prints" do
    column "Product Name" do |l|
      l.name
    end
    column :description do |l|
      l.description.html_safe() if l.description
    end
    column :sides
    column "status" do |l|
      if l.status
        status_tag "Active", :ok
      else
        status_tag "Deactive"
      end
    end
    column :created_at
    column :updated_at
    actions defaults: false, dropdown: true, dropdown_name: "Options" do |l|
      item("Manage Product", admin_large_print_path(l))
      item("Edit Product", edit_admin_large_print_path(l))
      item("Remove Product", admin_large_print_path(l), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      item("Add Material", new_admin_large_print_material_path(large_print_id: l.id, name: l.name))
    end
  end

  show do
    div class: "group" do
      div class: "large-print-main" do
        attributes_table do
          row "Product Name" do |l|
            l.name
          end
          row "Display Image" do |l|
            image_tag(l.display_image.url(), class: "display-image")
          end
          row :description do |l|
            l.description.html_safe() if l.description
          end
          row :sides
          row "status" do |l|
            if l.status
              status_tag "Active", :ok
            else
              status_tag "Deactive"
            end
          end
        end
      end
      div class: "material-list" do
        panel("Materials", class: "group")do
          table_for large_print.large_print_materials do
            column :material_image do |m|
              image_tag m.material_image.url(), class: "material_image"
            end
            column :material_name
            column "Thicknesses" do |m|
              m.material_thicknesses.map do |t|
                link_to_view_thickness_detail("#{t.thickness}#{t.unit.downcase}", m, t)
              end.join(" | ").html_safe()
            end
            column "", class: "material-actions" do |m|
              dropdown_menu "Options" do
                item("Add Thickness", new_admin_material_thickness_path(id: m.id, large_print_id: m.large_print_id))
                item("Edit", edit_admin_large_print_material_path(m, large_print_id: large_print.id, name: large_print.name))
                item("Delete", admin_large_print_material_path(m,large_print_id: m.large_print_id), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
              end
            end

          end
          text_node link_to "Add New Material", new_admin_large_print_material_path(large_print_id: large_print.id, name: large_print.name), class: "link_button right"
        end

      end
    end
    div class: "material-detail-wrapper" do
    end
  end

  form do |f|
    f.inputs do 
      f.input :name, label: "Large Print Name"
      f.input :description, input_html: { class: "tinymce" }
      f.input :display_image, :as => :file
      f.input :sides, :as => :select, :collection => options_for_select(["1", "2"], f.object.sides)
      f.input :status, :as => :select, :collection => options_for_select([['Active', true], ['Deactive', false]], f.object.status)
    end
    f.actions
  end

  controller do
    
    def destroy
      super do |format|
        redirect_to :back and return
      end
    end
  end

end
