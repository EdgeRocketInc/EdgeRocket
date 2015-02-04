class AddSurveyIdToRecommendationsEmail < ActiveRecord::Migration
  def change
    add_column :recommendations_emails, :survey_id, :integer
  end
end
