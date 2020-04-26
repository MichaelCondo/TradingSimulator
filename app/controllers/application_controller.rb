class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_valid_user!

  def current_user
    if !session[:user_id].blank?
      @user ||= User.find(session[:user_id])
    end
  end

  def require_valid_user!
    if current_user.nil?
      flash[:error] = 'You must be logged in to access that page!'
      @signed_in = false
      redirect_to login_path
    else
      @signed_in = true
    end
  end
end
