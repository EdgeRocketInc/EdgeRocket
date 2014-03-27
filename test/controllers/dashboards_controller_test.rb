require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase
  setup do
  end

  test "should show dashboard" do
    get :show
    assert_response :redirect
  end

end
