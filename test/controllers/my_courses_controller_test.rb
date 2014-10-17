require 'test_helper'

class MyCoursesControllerTest < ActionController::TestCase
  test "should get index" do
    sign_in User.find(101)
    get :index
    assert_response :success
  end

  test "should get index json" do
    sign_in User.find(103)
    get :index, {format: 'json'}
    assert_response :success
  end

  test "should get show json" do
    sign_in User.find(103)
    get(:show, {:product_id => 2006, :format => 'json'})
    assert_response :success
  end

  test "course subscription current user" do
    sign_in User.find(101)
    mc = MyCourse.where("product_id=2006 and user_id=101").first
    assert mc.nil?
    post(:subscribe, {course_id: '2006', format: 'json'})
    assert_response :success
    mc = MyCourse.where("product_id=2006 and user_id=101").first
    assert !mc.nil? && mc.product_id==2006, 'my courses not found'
  end

  test "assing course to a user" do
    sign_in User.find(101)
    mc = MyCourse.where("product_id=2004 and user_id=103").first
    assert mc.nil?
    post(:subscribe, {course_name: 'Project Management', user_email: 'test2-user@edgerocket.co', format: 'json'})
    assert_response :success
    mc = MyCourse.where("product_id=2004 and user_id=103").first
    assert !mc.nil? && mc.product_id==2004, 'my courses not found'
  end

  test "update course subscription" do
    sign_in User.find(101)
    #put(:update_subscription, {:id => 2006, :format => 'json'}, nil)
    assert_response :success
  end


end
