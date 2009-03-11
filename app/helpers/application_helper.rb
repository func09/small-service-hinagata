# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Return HTML what flash messages.
  def flash_message
    message = ""
    [:notice,:info,:warning,:error].each do |type|
      message << "<div id='flash-#{type}'>#{flash[type]}</div>\n"
    end
    message
  end
  
end
