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
    end
  end

  def buy
    @parameter = session[:stock_parameter]
  end

  def sell
    @parameter = session[:stock_parameter]
  end

end
