require 'test_helper'

class RecommendationsEmailTest < ActiveSupport::TestCase
  
  test "save recommendations email" do
  	current_user = User.find(101)
  	recommendations_hash = RecommendationsEmail.save_recommendations_email(
  		current_user, 
  		[], 
  		current_user.survey.id)
  	assert !recommendations_hash.nil?
  end

end
