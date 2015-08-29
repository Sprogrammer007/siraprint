ActiveAdmin.register PlasticCardPrice do

  menu false

  permit_params :minx, :max, :rate

  form do |f|
    f.inputs do
      f.input :plastic_card_id, :as => :hidden, :input_html => { value: "#{params[:plastic_card_id] }"}
      f.input :min
      f.input :max
      f.input :rate
    end

    f.actions
  end

   controller do
    def create
      super do |format|
        redirect_to admin_plastic_card_path(params[:plastic_card_price][:plastic_card_id])
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_plastic_card_path(params[:plastic_card_price][:plastic_card_id])
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