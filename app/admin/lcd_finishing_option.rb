ActiveAdmin.register LcdFinishingOption do

  menu false

  controller do
    def create
      LcdFinishingOption.where(lcd_id: params[:lcd_id]).delete_all
      if params[:finishings_ids]
        ids = params[:finishings_ids].map { |id| {:lcd_finishing_id => id }}
        LcdFinishingOption.create(ids) do |f|
          f.lcd_id = params[:lcd_id]
        end
        flash[:notice] = "Successfully updated finishing options!"
      end
			redirect_to admin_led_path(params[:lcd_id])
    end

  end

end