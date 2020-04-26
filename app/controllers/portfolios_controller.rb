class PortfoliosController < ApplicationController
  def show
    @current_user ||= User.find(session[:user_id])
  end
end
