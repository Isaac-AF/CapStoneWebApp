class ApplicationController < ActionController::Base
  skip_forgery_protection

  helper ApplicationHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name,
      :birthday,
      :sex,
      :height,
      :weight,
      :activity_level,
      :primary_goal,
      :secondary_goal,
      :tertiary_goal,
      :dietary_restrictions
    ])
  end

  def after_sign_in_path_for(resource)
    "/users/#{resource.id}"
  end
  
end
