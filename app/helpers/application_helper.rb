# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_boolean( boolean_value )
    if boolean_value
      "Yes"
    else
      "No"
    end
  end
end
