class SliderImagesController < ApplicationController
  
  def create
    @slide = SliderImage.create(permitted_params)
  end

  def destroy
    SliderImage.find(params[:id]).destroy!
    redirect_to :back and return
  end

  private

    def permitted_params
       params.require(:slider_image).permit(:slide_image, :product_type) 
    end
end