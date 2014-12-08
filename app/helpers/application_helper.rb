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

  def cp(path)
    "active" if current_page?(path)
  end

  def badge_number
    current_user.open_order ? current_user.open_order.ordered_products.count() : 0
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
