require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get login_main_url
    assert_response :success
  end

end
