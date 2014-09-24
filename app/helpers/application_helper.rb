module ApplicationHelper

	# Helper Method for Page Title
  def page_title(title)
    base_title = "Sira Print"
    if title.empty?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end
end
