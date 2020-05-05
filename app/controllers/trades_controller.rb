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
        @portfolio_stock = @current_user.portfolio.portfolio_stocks.where(:ticker => @response['symbol']).first
        if @portfolio_stock.present?
          session[:buy_quantity] = params[:quantity]
          flash[:success] = 'Order filled'
          @book_cost = params[:quantity].to_i * @response['price']
          @portfolio_stock.book_cost = @portfolio_stock.book_cost + @book_cost
          @portfolio_stock.current_price = @response['price']
          @portfolio_stock.quantity = @portfolio_stock.quantity + params[:quantity].to_i
          @portfolio_stock.market_value = @portfolio_stock.market_value + @book_cost
          @portfolio_stock.save!
          @current_user.portfolio.cash = @current_user.portfolio.cash - @book_cost
          @current_user.portfolio.investment_value = @current_user.portfolio.investment_value + @book_cost
          @current_user.portfolio.book_cost = @current_user.portfolio.book_cost + @book_cost
          @current_user.portfolio.save!
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
      end
    else
      # Raise alert if no quantity or quantity <= 0
      flash[:error] = 'Specify Quantity'
    end
  end

  def sell
    @selected_ticker = ''
    @parameter = session[:stock_parameter]
    @current_user ||= User.find(session[:user_id])
    @cash = @current_user.portfolio.cash
    @stock_tickers = @current_user.portfolio.portfolio_stocks.map {|stock| [stock.ticker + ", " + stock.name]}

    if params[:quantity].present? && params[:quantity].to_i > 0
      @selected_ticker = params[:ticker].to_s.split(", ").first
      @sold_stock = @current_user.portfolio.portfolio_stocks.where(:ticker => @selected_ticker).first
      @sell_quantity = @sold_stock.quantity
      session[:sold_stock] = @sold_stock
      if params[:quantity].to_i > @sold_stock.quantity
        flash[:error] = 'Quantity exceeds how much you own'

      elsif params[:quantity].to_i == @sold_stock.quantity
        # If user wants to sell entire position, destroy PortfolioStock object
        @price = HTTParty.get('https://financialmodelingprep.com/api/v3/quote/' + @selected_ticker).parsed_response.first['price']
        session[:sold_price] = @price
        @current_user.portfolio.cash += @price * @sold_stock.quantity
        @current_user.portfolio.portfolio_stocks.where(:ticker => @selected_ticker).first.destroy
        @current_user.portfolio.save!
        flash[:success] = 'Order sold'
        session[:sell_quantity] = params[:quantity]
      else
        # If user only wants to sell a portion of their position
        @price = HTTParty.get('https://financialmodelingprep.com/api/v3/quote/' + @selected_ticker).parsed_response.first['price']
        session[:sold_price] = @price
        flash[:success] = 'Order sold'
        session[:sell_quantity] = params[:quantity]
      end
    else
      # Raise alert if no quantity or quantity <= 0
      flash[:error] = 'Specify Quantity'
    end
  end

  def buy_order
    @stock_info = session[:parsed_response]
    @quantity = session[:buy_quantity]
  end

  def sell_order
    @quantity = session[:sell_quantity]
    @stock_info = session[:sold_stock]
    @sold_price = session[:sold_price]
  end

end
