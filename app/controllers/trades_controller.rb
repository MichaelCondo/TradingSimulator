class TradesController < ApplicationController
  include HTTParty

  def search
    if params[:search].blank?
      @parameter = ''
      session[:stock_parameter] = @parameter
    else
      @parameter = params[:search].upcase
      session[:stock_parameter] = @parameter
      @response = HTTParty.get('https://financialmodelingprep.com/api/v3/quote/' + @parameter.to_s)
      session[:parsed_response] = @response.parsed_response.first
    end
  end

  def buy
    @parameter = session[:stock_parameter]
    @response = session[:parsed_response]
    @current_user ||= User.find(session[:user_id])
    @cash = @current_user.portfolio.cash
    if params[:quantity].present? && params[:quantity].to_i > 0
      if (params[:quantity].to_i * @response['price']) > @cash
        flash[:error] = 'Not enough cash'
      else
        session[:buy_quantity] = params[:quantity]
        flash[:success] = 'Order filled'
        @book_cost = params[:quantity].to_i * @response['price']
        @response_2 = HTTParty.get('https://financialmodelingprep.com/api/v3/financials/income-statement/' + @parameter.to_s)
        @dividend_per_share = @response_2.parsed_response['financials'].first['Dividend per Share'].to_f
        @dividend_yield = (@dividend_per_share / @response['price']) * 100
        # Create portfolio stock for this user's portfolio
        PortfolioStock.create!(:portfolio_id => @current_user.portfolio.id,
                              :ticker => @response['symbol'],
                              :name => @response['name'],
                              :current_price => @response['price'],
                              :exchange => @response['exhange'],
                              :quantity => params[:quantity].to_i,
                              :book_cost => @book_cost,
                              :market_value => @book_cost,
                              :gain_loss => 0.0,
                              :dividend_per_share => @dividend_per_share,
                              :dividend_yield => @dividend_yield)

        @current_user.portfolio.cash = @current_user.portfolio.cash - @book_cost
        @current_user.portfolio.investment_value = @current_user.portfolio.investment_value + @book_cost
        @current_user.portfolio.book_cost = @current_user.portfolio.book_cost + @book_cost
        @current_user.portfolio.save!
      end
    else
      # Raise alert if no quantity or quantity <= 0
      flash[:error] = 'Specify Quantity'
    end
  end

  def sell
    @parameter = session[:stock_parameter]
  end

  def buy_order
    @stock_info = session[:parsed_response]
    @quantity = session[:buy_quantity]
  end

end
