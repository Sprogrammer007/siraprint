module ApplicationHelper

	# Helper Method for Page Title
  def page_title(title)
    base_title = "Sira Print: Toronto Based 24 Hour Printing Services"
    if title.empty?
      base_title
    else
      "#{title} | Sira Print"
    end
  end  
  def meta(description)
 
    if description.empty?
      "Sira Print provides various printing services of decals, banners, posters, canvas, magnets, vinyl, A-frame, die cut stickers, business cards on almost all surfaces."
    else
      "#{description}"
    end
  end

  def cp(path)
    "active" if current_page?(path)
  end

  def current_active
    active_user = current_broker || current_user
    return active_user
  end

  def active_signed_in?
    return broker_signed_in? || user_signed_in?
  end

  def badge_number
    current_active.open_order ? current_active.open_order.ordered_products.count() : 0
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
