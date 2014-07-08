require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    sign_in User.find(103)
  end

  test "should create user json" do
    assert_difference('User.count') do
      post :create, employee: { email: 'abc@test.com', password: '12345678' }, :format => 'json'
    end
  end

end
