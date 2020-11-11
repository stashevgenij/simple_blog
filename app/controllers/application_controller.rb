class ApplicationController < ActionController::Base
  def require_valid_user!
    return unless current_user.nil?
    flash[:error] = 'You need to log in'
    redirect_to new_user_session_path
  end
end
