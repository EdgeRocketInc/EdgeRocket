require 'test_helper'

class ProfileControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)
    sign_in User.find(103)
  end

  test "should update profile" do
    put :update, profile: { first_name: 'First' }, :format => 'json'
  end

end
