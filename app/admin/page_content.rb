ActiveAdmin.register PageContent do

  menu false
  permit_params :name, :content, :link, :id, :image_file_name

  form do |f|
    f.inputs do
      f.input :name, label: "Name"
      
    end
  
    
    f.actions
  end
  controller do
    def create

      super do |format|
        redirect_to admin_pages_path()
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_pages_path()
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