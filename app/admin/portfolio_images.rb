ActiveAdmin.register_page "Portfolio Images" do
  menu :parent => "Global"

  content do
    div class: "slides" do
      if SliderImage.portfolio.any?
        SliderImage.portfolio.each do |image|
          render "slider_images/slider_image", slider_image: image
        end
      end
    end
    render "admin/upload_slider", type: "portfolio"

  end
end

