ActiveAdmin.register OrderedProduct do

  menu false

  
  controller do
    
    def destroy
      super do |format|
        redirect_to :back and return
      end
    end
  end


end
