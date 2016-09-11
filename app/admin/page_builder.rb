ActiveAdmin.register_page "Page Builder" do
 


  controller do
    def index
     
      @page = Page.find(params[:id])
     
    
    end
  end

  content do
   
    render "admin/home_form", page: @arbre_context.assigns[:page]
  end
end

