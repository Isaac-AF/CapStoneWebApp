class ApplicationController < ActionController::Base
  skip_forgery_protection

  helper ApplicationHelper

  # Require a logged-in user for everything by default
  before_action :require_login
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :birthday, :sex, :height, :weight, :activity_level,
      :primary_goal, :secondary_goal, :tertiary_goal, :dietary_restrictions
    ])
  end

  def after_sign_in_path_for(resource)
    "/users/#{resource.id}"
  end

  private

  def require_login
    return if user_signed_in?

    # Remember where they were trying to go (best for GETs)
    store_location_for(:user, request.fullpath) if request.get?

    respond_to do |format|
      format.html do
        redirect_to new_user_session_path, alert: "Please sign in to continue."
      end
      format.turbo_stream do
        redirect_to new_user_session_path, alert: "Please sign in to continue."
      end
      format.json do
        render json: { error: "unauthenticated", redirect_to: new_user_session_url }, status: :unauthorized
      end
      format.js do
        render js: "window.location = #{view_context.javascript_escape(new_user_session_path).inspect};",
               status: :unauthorized
      end
      # Fallback for anything else
      format.any do
        redirect_to new_user_session_path, alert: "Please sign in to continue."
      end
    end
  end
end
