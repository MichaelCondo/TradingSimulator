class DividendController < ApplicationController
  def show
    @current_user ||= User.find(session[:user_id])
    @has_stocks = @current_user.portfolio.portfolio_stocks.present?
    @total_dividends = 0.0
    @data = []

    @current_user.portfolio.portfolio_stocks.each do |stock|
      @total_dividends += stock.dividend_per_share * stock.quantity
      @data << [stock.name, (stock.dividend_per_share * stock.quantity).to_f, '#0CBE86']
    end
  end
end
