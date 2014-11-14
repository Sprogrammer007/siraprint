ActiveAdmin.register LargeFormatTier do

  menu false

  permit_params :large_format_thickness_id, :level, :min_sqft, :max_sqft, :price

  form do |f|
    f.inputs do
      f.input :large_format_id, :as => :hidden, :input_html => { value: "#{params[:large_format_id] }"}
      f.input :large_format_thickness_id, :as => :hidden, :input_html => { value: "#{params[:large_format_thickness_id]}" }
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
        redirect_to admin_large_format_path(params[:large_format_tier][:large_format_id])
        return
      end
    end

    def update 
      super do |format|
        redirect_to admin_large_format_path(params[:large_format_tier][:large_format_id])
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
