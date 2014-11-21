ActiveAdmin.register Post do

  menu :parent => "Content"

  permit_params :title, :excerpt, :content, :featured_image,
  :author, :category

  #Filters
  filter :title
  filter :author
  filter :category
  filter :created_at


  #Index Table
  index do
    column :title
    column "Excerpt" do |p|
      p.excerpt.html_safe() if p.excerpt
    end
    column :author
    column "Published On" do |p|
      p.created_at.strftime("%m-%d-%Y")
    end
    column "" do |p|
      dropdown_menu "Actions" do 
        item("View Post Details", admin_post_path(p))
        item("Edit Post", edit_admin_post_path(p))
        item("Delete Post", admin_post_path(p), method: :delete, data: {confirm: I18n.t('active_admin.delete_confirmation')})
      end
    end
  end

  form :html => {:multipart => true} do |f|
    f.inputs do 
      f.input :title
      f.input :excerpt, input_html: { class: "tinymce" }
      f.input :content, input_html: { class: "tinymce" }
      f.input :author
      f.input :category
      f.input :featured_image, :as => :file
    end
    f.actions
  end

end
