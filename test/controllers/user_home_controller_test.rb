require 'test_helper'

class UserHomeControllerTest < ActionController::TestCase
  test "should get index html" do
    sign_in User.find(101)
    get :index
    assert_response :success
  end

  test "should get user_playlists json" do
    sign_in User.find(101)
    get :user_playlists_json, :format => 'json'
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

  test "playlist subscription" do
    sign_in User.find(101)
    post(:subscribe, {playlist_ids: ['1003'], format: 'json'})
    assert_response :success
  end

  test "playlist unsubscribe" do
    sign_in User.find(101)
    delete(:unsubscribe, {id: '1001', format: 'json'})
    assert_response :success
  end

  test "playlist unsubscribe without cascading" do
    sign_in User.find(101)
    delete(:unsubscribe, {id: '1001', cascade: false, format: 'json'})
    assert_response :success
  end

  test "create preferences without skills" do
    sign_in User.find(101)

    post(:create_preferences, format: 'json' )
    assert_response :success

    skills_empty = []

    post(:create_preferences, { skills: skills_empty, format: 'json'} )
    assert_response :success
  end

  test "create preferences set skills" do
    sign_in User.find(101)

    skills_real = [ {id: 'marketing'}, {id: 'seo'} ]

    post(:create_preferences, { skills: skills_real, format: 'json'} )
    assert_response :success
  end

end
