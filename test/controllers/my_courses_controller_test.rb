require 'test_helper'

class MyCoursesControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.first
    get :index
    assert_response :success
  end

end
