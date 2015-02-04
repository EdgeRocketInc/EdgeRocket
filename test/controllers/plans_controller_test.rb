require 'test_helper'

class PlansControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.find(103)
    get :index
    assert_response :success
  end

end
