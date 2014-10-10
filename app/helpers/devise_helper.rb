module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="bg-danger radius-r mbs"> 
      <button type="button" class="close"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>      <div class="error_messages">
        #{messages}
      </div>
    </div>
    HTML

    html.html_safe
  end
end