module ApplicationHelper
  def devise_error_messages1!
    resource.errors.full_messages
  end  
end
