require 'test_helper'

class MyCoursesControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.find(101)
    get :index, {format: 'json'}
    assert_response :success
  end

  test "should get index json" do
    sign_in User.find(103)
    get :index
    assert_response :success
  end

  test "course subscription" do
    sign_in User.find(101)
    post(:subscribe, {course_id: '2006', format: 'json'})
    assert_response :success
  end

  test "update course subscription" do
    sign_in User.find(101)
    # TODO fix this test
    #put(:update_subscription, :id => '1001', {status: 'wip', format: 'json'})
    assert_response :success
  end


end
