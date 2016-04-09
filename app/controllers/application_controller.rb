class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  def require_logged_in
    return true if current_user
    redirect_to root_path
    return false
  end
end
