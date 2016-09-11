ActiveAdmin.register Page do

  menu :parent => "Content"

  permit_params :title,
  :page_contents_attributes => [:id, :name, :content, :image_file, :link,  :_destroy => true ]

  #Filters
  filter :title
  filter :created_at


  #Index Table
  index do
    column :title
    column "" do |p|
      dropdown_menu "Actions" do 
        item("Edit Page", admin_page_builder_path({id: p.id}))
        item("Delete Page", admin_page_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      end
    end
  end

  form :html => {:multipart => true} do |f|
    f.inputs do 
      f.input :title
    end
   
    f.has_many :page_contents, :allow_destroy => true, :heading => false, :new_record => true do |t|
      t.input :name
      t.input :content, input_html: { class: "tinymce" } 
    end
    f.actions
  end

end
