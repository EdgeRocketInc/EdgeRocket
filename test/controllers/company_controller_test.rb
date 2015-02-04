require 'test_helper'

class CompanyControllerTest < ActionController::TestCase
  test "should get index html" do
    sign_in User.find(101)
    get :index
    assert_response :success
  end

  test "should get account json" do
    sign_in User.find(101)
  	get :account, {format: 'json'}
    assert_response :success
  end


end
