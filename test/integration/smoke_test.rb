require 'test_helper'
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :users
 
  test "login and browse site" do
    get "/users/sign_in"
    assert_response :success
    # TODO
  end
end