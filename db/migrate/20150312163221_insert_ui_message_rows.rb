class InsertUiMessageRows < ActiveRecord::Migration
  def change
  	UiMessage.create(:id => 1, :message_body => 'You subscribed to new Courses that have been added to your list.')
  	UiMessage.create(:id => 2, :message_body => 'Based on the skills section of your LinkedIn profile, EdgeRocket has populated recommended learning content for you below.')
  	UiMessage.create(:id => 3, :message_body => 'Based on the interests you selected, EdgeRocket has populated recommended learning content for you below.')
  end
end
