require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  test "should get index auth" do
    sign_in User.first

    get :index
    assert_response :redirect
  end

  test "should get index not auth" do
    sign_out User.first
    get :index
    assert_response :redirect
  end

end
