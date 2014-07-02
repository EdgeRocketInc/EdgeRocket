require 'test_helper'

class MyCoursesTest < ActiveSupport::TestCase
  

 	test "courses per user" do
 		crs_user = MyCourse.courses_per_user(101)
     	assert !crs_user.nil?
  	end
end
