class LoginController < ApplicationController
  def main
    render json: { status: "It's working" }
  end
end
