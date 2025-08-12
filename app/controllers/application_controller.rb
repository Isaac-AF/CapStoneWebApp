class ApplicationController < ActionController::Base
  # Enable CSRF protection
  protect_from_forgery with: :exception

  # Require auth for everything by default; skip in public controllers/actions as needed
  before_action :authenticate_user!

  helper ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  # If a user leaves a page open, their session/CSRF token can expire.
  # Catch that and send them to sign in gracefully.
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_session_expired

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

  def handle_session_expired
    # Optionally remember where they were going
    store_location_for(:user, request.fullpath) if request.get?

    respond_to do |format|
      format.html do
        redirect_to new_user_session_path, alert: "Your session expired. Please sign in again."
      end
      format.turbo_stream do
        # Turbo treats redirect like HTML; keep the same message
        redirect_to new_user_session_path, alert: "Your session expired. Please sign in again."
      end
      format.json do
        render json: { error: "session_expired", redirect_to: new_user_session_url }, status: :unauthorized
      end
      format.js do
        # For legacy rails-ujs requests
        render js: "window.location = #{view_context.javascript_escape(new_user_session_path).inspect};",
               status: :unauthorized
      end
    end
  end
end
