ActiveAdmin.register_page "Home Slider Images" do
  menu :parent => "Global"

  content do
    div class: "slides" do
      if SliderImage.home.any?
        SliderImage.home.each do |image|
          render "slider_images/slider_image", slider_image: image
        end
      end
    end
    render "admin/upload_slider", type: "home"

  end
end

