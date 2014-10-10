ActiveAdmin.register LargePrintMaterial do

  menu false

  permit_params( :material_name, :material_image, :large_print_id, 
    :material_thicknesses_attributes => [ :thickness, :unit, :_destroy, :id,
    :large_print_tiers_attributes => [ :level, :min_sqft, :max_sqft, :price, :id, :_destroy ] ], 
    )
  
  #Filters
  filter :material_name

  index :title => "Large Prints" do
  end

  form :partial => "form"

  controller do 

    def new
      if params[:name]
        @page_title = "New Material For #{params[:name]}"
      end
      super
    end

    def create
      @large_print = LargePrint.find(params[:large_print_material][:large_print_id])

      if @large_print
        @lpm = LargePrintMaterial.new(permitted_params[:large_print_material])
        @lpm.save        
      else 
      end
      redirect_to admin_large_print_path(@large_print)
    end

    def update 
      @large_print = LargePrint.find(params[:large_print_material][:large_print_id])
      lpm = LargePrintMaterial.find(params[:id])
      lpm.update(large_print_id: params[:large_print_material][:large_print_id],
        material_name: params[:large_print_material][:material_name],
        material_image: params[:large_print_material][:material_image])

      thickness_attrs = params[:large_print_material][:material_thicknesses_attributes]
        
      thickness_attrs.each_value do |attrs|
        tier_attrs = attrs[:large_print_tiers_attributes]

        if attrs[:id]
          m = MaterialThickness.find(attrs[:id])
        end

        if attrs[:_destroy] == '1'
          m.destroy 
        elsif attrs[:id].nil?
          new_m = lpm.material_thicknesses.create!(:thickness => attrs[:thickness], :unit => attrs[:unit])
          if tier_attrs
            tier_attrs.each_value do |a|
              new_m.large_print_tiers.create!(:level => a[:level], :min_sqft => a[:min_sqft],
                :max_sqft => a[:max_sqft], :price => a[:price])
            end
          end 
        else
          MaterialThickness.find(attrs[:id]).update(:thickness => attrs[:thickness], :unit => attrs[:unit])
        end

        if attrs[:id] && attrs[:_destroy] != '1' && tier_attrs
          tier_attrs.each_value do |a|
            if a[:_destroy] == '1'
              LargePrintTier.find(a[:id]).destroy
            elsif a[:id].nil?
              m.large_print_tiers.create!(:level => a[:level], :min_sqft => a[:min_sqft],
                :max_sqft => a[:max_sqft], :price => a[:price])
            else
              LargePrintTier.find(a[:id]).update(:level => a[:level], :min_sqft => a[:min_sqft],
                :max_sqft => a[:max_sqft], :price => a[:price])
            end
          end
        end
      end
      
      redirect_to admin_large_print_path(@large_print)
    end

  end

end
