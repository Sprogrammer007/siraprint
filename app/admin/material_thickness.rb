ActiveAdmin.register MaterialThickness do

  menu false

  permit_params :large_print_material_id, :thickness, :unit, :large_print_tiers_attributes => [ :level, :min_sqft, :max_sqft, :price ] 


  form do |f|
    if f.object.new_record?
      f.inputs do
        f.input :large_print_material_id, :as => :hidden, :input_html => { value: "#{params[:id]}" } 
        f.input :large_print_id, :as => :hidden, :input_html => { value: "#{params[:large_print_id] }"}
        f.input :thickness, label: "Thickness"
        f.input :unit, :as => :select, :collection => options_for_select(["cm", "mm"])
      end
      f.inputs do
        f.has_many :large_print_tiers, :allow_destroy => true, :heading => 'Price Tiers'do |tf|
          tf.input :id, :as => :hidden
          tf.input :level  
          tf.input :min_sqft
          tf.input :max_sqft
          tf.input :price
        end
      end
    else
      f.inputs do 
        f.input :large_print_id, :as => :hidden, :input_html => { value: "#{params[:large_print_id] }"}
        f.input :thickness, label: "Thickness"
        f.input :unit, :as => :select, :collection => options_for_select(["cm", "mm"], f.object.unit.downcase)
      end
    end
    f.actions
  end

   controller do
    def create
      @large_print = LargePrint.find(params[:material_thickness][:large_print_id])

      super do |format|
        redirect_to admin_large_print_path(@large_print)
        return
      end
    end

    def update 
      @large_print = LargePrint.find(params[:material_thickness][:large_print_id])
      super do |format|
        redirect_to admin_large_print_path(@large_print)
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