require 'test_helper'

class DividendControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get dividend_show_url
    assert_response :success
  end

end
