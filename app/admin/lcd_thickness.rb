ActiveAdmin.register LcdThickness do

  menu false

  permit_params :lcd_id, :thickness, :unit, :lcd_tiers_attributes => [:id, :level, :min_sqft, :max_sqft, :price, :_destroy => true] 


  form do |f|
    f.inputs do
      f.input :thickness, label: "Thickness"
      f.input :unit, :as => :select, :collection => options_for_select(['cm', 'mm', 'pt', 'mil', 'inch'], f.object.unit)
      f.input :lcd_id, :as => :hidden, :input_html => { value: "#{params[:lcd_id] }"}
    end
    
    f.has_many :lcd_tiers, :allow_destroy => true, :heading => 'Tiers' do |tf|
      tf.input :level  
      tf.input :min_sqft
      tf.input :max_sqft
      tf.input :price
    end
    
    f.actions
  end

   controller do
    def create
      super do |format|
        redirect_to admin_lcd_path(params[:lcd_thickness][:lcd_id])
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_lcd_path(params[:lcd_thickness][:lcd_id])
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