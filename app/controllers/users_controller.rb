class UsersController < ApplicationController
  skip_before_action :require_valid_user!
  before_action :reset_session

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @portfolio = Portfolio.create!(user_id: @user.id, portfolio_value: 0.00, gain_loss: 0.00,
        investment_value: 0.00, book_cost: 0.00, cash: 0.00)
      @portfolio.save
      session[:user_id] = @user.id
      flash[:success] =  'You have successfully created an account!'
      redirect_to root_path
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
