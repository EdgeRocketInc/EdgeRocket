require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  setup do
  end

  test "should show dashboard" do
    sign_in User.find(102)
    get :show
    # TODO test  @users[:total_count] > 0, "user count"
    assert_response :success
  end

end
