require 'test_helper'

class UserHomeControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.find(101)
    get :index
    assert_response :success
  end

  test "should have playlists" do
    sign_in User.find(102)
    get :index
    assert_response :success
  end

end
