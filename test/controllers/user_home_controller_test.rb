require 'test_helper'

class UserHomeControllerTest < ActionController::TestCase
  test "should get index html" do
    sign_in User.find(101)
    get :index
    assert_response :success
  end

  test "should get index json" do
    sign_in User.find(101)
    get :index, :format => 'json'
    assert_response :success
  end

  test "should get current user json" do
    sign_in User.find(101)
    get :get_user, :format => 'json'
    assert_response :success
  end

  test "should have playlists" do
    sign_in User.find(102)
    get :index
    assert_response :success
  end

  test "playlits subscription" do
    sign_in User.find(101)
    post(:subscribe, {id: '1001', playlist_id: '1003', format: 'json'})
    assert_response :success
  end

  test "playlist unsubscribe" do
    sign_in User.find(101)
    delete(:unsubscribe, {id: '1001', format: 'json'})
    assert_response :success
  end

end
