class PortfoliosController < ApplicationController
  include HTTParty

  def show
    @current_user ||= User.find(session[:user_id])
    @has_stocks = @current_user.portfolio.portfolio_stocks.present?

    if @has_stocks
      @port_inv_value = 0.0
      @book_cost = 0.0
      @current_user.portfolio.portfolio_stocks.each do |stock|
        @response = HTTParty.get('https://financialmodelingprep.com/api/v3/quote/' + stock.ticker)
        stock.current_price = @response.parsed_response.first['price']
        stock.market_value = @response.parsed_response.first['price'] * stock.quantity
        stock.gain_loss = (@response.parsed_response.first['price'] * stock.quantity) - stock.book_cost
        stock.save!
        @port_inv_value = @port_inv_value + (@response.parsed_response.first['price'] * stock.quantity)
        @book_cost = @book_cost + stock.book_cost
      end

      @current_user.portfolio.investment_value = @port_inv_value
      @current_user.portfolio.book_cost = @book_cost
      @current_user.portfolio.portfolio_value = @port_inv_value + @current_user.portfolio.cash
      @current_user.portfolio.gain_loss = @port_inv_value - @book_cost
      @current_user.portfolio.save!
    end
  end
end
