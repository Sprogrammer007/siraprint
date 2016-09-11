ActiveAdmin.register_page "Home Page" do

  page = Page.home[0]
  Rails.logger.warn page
  content do


    render "admin/home_form", page: page
  end
end

