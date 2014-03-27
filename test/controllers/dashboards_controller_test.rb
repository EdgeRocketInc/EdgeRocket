require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  setup do
  end

  test "should show dashboard" do
    get :show
    # TODO test  @users[:total_count] > 0, "user count"
    assert_response :redirect
  end

end
