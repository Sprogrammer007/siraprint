ActiveAdmin.register MetalSignSize do

  menu false

  permit_params :width, :height, :unit


  form do |f|
    f.inputs do
      f.input :metal_sign_id, :as => :hidden, :input_html => { value: "#{params[:metal_sign_id] }"}
      f.input :width
      f.input :height
      f.input :unit, :as => :select, :collection => options_for_select(['inch'], f.object.unit)
      f.input :price
    end

    f.actions
  end

   controller do
    def create
      super do |format|
        redirect_to admin_metal_sign_path(params[:metal_sign_size][:metal_sign_id])
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_metal_sign_path(params[:metal_sign_size][:metal_sign_id])
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