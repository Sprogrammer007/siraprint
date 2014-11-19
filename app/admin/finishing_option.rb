ActiveAdmin.register FinishingOption do

  menu false

  controller do
    def create
      FinishingOption.where(large_format_id: params[:large_format_id]).delete_all
      if params[:finishings_ids]
        ids = params[:finishings_ids].map { |id| {:large_format_finishing_id => id }}
        FinishingOption.create(ids) do |f|
          f.large_format_id = params[:large_format_id]
        end
        flash[:notice] = "Successfully updated regions!"
      end
      redirect_to admin_large_format_path(params[:large_format_id])
    end

  end

end