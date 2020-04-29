module PortfolioHelper
  include ActionView::Helpers::NumberHelper

  def format_to_currency(number)
    number_to_currency(number)
  end

end
