require 'test_helper'

class MyCoursesControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.first
    get :index
    assert_response :success
  end

  test "course subscription" do
    sign_in User.find(101)
    post(:subscribe, {course_id: '2006', format: 'json'})
    assert_response :success
  end

end
