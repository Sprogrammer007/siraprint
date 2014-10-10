ActiveAdmin.register LargePrintTier do

  menu false

  permit_params :material_thickness_id, :level, :min_sqft, :max_sqft, :price

  form do |f|
    f.inputs do
    	f.input :large_print_id, :as => :hidden, :input_html => { value: "#{params[:large_print_id] }"}
      f.input :material_thickness_id, :as => :hidden, :input_html => { value: "#{params[:material_thickness_id]}" }
      f.input :level, label: "Large Tier Level"
      f.input :min_sqft
      f.input :max_sqft
      f.input :price
    end
    f.actions
  end

  controller do
  	def create
      @large_print = LargePrint.find(params[:large_print_tier][:large_print_id])

	    super do |format|
	      redirect_to admin_large_print_path(@large_print)
	      return
	    end
    end

	  def update 
	  	@large_print = LargePrint.find(params[:large_print_tier][:large_print_id])
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
