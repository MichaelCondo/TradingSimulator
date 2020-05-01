class PortfoliosController < ApplicationController
  def show
    @current_user ||= User.find(session[:user_id])
    @has_stocks = @current_user.portfolio.portfolio_stocks.present?

    
  end
end
