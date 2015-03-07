ActiveAdmin.register LargeFormatThickness do

  menu false

  permit_params :large_format_id, :thickness, :unit, :large_format_tiers_attributes => [:id, :level, :min_sqft, :max_sqft, :price, :_destroy => true] 


  form do |f|
    f.inputs do
      f.input :thickness, label: "Thickness"
      f.input :unit, :as => :select, :collection => options_for_select(['cm', 'mm', 'pt', 'mil', 'inch'], f.object.unit)
      f.input :large_format_id, :as => :hidden, :input_html => { value: "#{params[:large_format_id] }"}
    end
    
    f.has_many :large_format_tiers, :allow_destroy => true, :heading => 'Tiers' do |tf|
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
        redirect_to admin_large_format_path(params[:large_format_thickness][:large_format_id])
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_large_format_path(params[:large_format_thickness][:large_format_id])
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