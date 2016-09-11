ActiveAdmin.register_page "Home Slider Images" do
  menu :parent => "Global"
  images = SliderImage.home
  content do
    div class: "slides" do
      if images.any?
        images.each do |image|
          render "slider_images/slider_image", slider_image: image
        end
      end
    end
    render "admin/upload_slider", type: "home"

  end
end

