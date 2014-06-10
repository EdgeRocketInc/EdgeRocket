require 'test_helper'

class DiscussionsControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.find(101)
    get :index
    assert_response :success
  end

  test "should get show" do
    sign_in User.find(101)
    get :show, id: 50
    assert_response :success
  end

  test "should create discussion" do
    sign_in User.find(103)
    post(:create_discussion, {title: 'new post', format: 'json'})
    assert_response :success
  end

end
