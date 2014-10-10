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

  # Convert Devise Alert keys to Booststrap
  def bs_alert_helper(key)
  	case key
  	when 'notice'
  		return 'success'	
  	when 'alert'
  		return 'danger'
  	else
  		return 'info'
  	end
  end
end
