ActiveAdmin.register LcdTier do

  menu false

  permit_params :lcd_thickness_id, :level, :min_sqft, :max_sqft, :price

  form do |f|
    f.inputs do
      f.input :lcd_id, :as => :hidden, :input_html => { value: "#{params[:lcd_id] }"}
      f.input :lcd_thickness_id, :as => :hidden, :input_html => { value: "#{params[:lcd_thickness_id]}" }
      f.input :level, label: "Tier Level"
      f.input :min_sqft
      f.input :max_sqft
      f.input :price
    end
    f.actions
  end

  controller do
    def create

      super do |format|
        redirect_to admin_lcd_path(params[:lcd_tier][:lcd_id])
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_lcd_path(params[:lcd_tier][:lcd_id])
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
