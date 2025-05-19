class ApplicationController < ActionController::Base
  skip_forgery_protection
  def after_sign_in_path_for(resource)
    "/users/#{resource.id}"
  end
end
