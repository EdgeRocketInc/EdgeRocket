require 'test_helper'

class SkillsControllerTest < ActionController::TestCase
  test "list skills" do
      	sign_in User.find(101)
    	get :list, :format => 'json'
    	assert_response :success
  end
end
