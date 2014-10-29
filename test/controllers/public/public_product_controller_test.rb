require 'test_helper'

class Public::PublicProductControllerTest < ActionController::TestCase

	setup do
	    @product = products(:one)
	    sign_in User.find(103)
	end

  	test "should show product" do
	    get :show, id: @product
	    assert_response :success
	end

end
