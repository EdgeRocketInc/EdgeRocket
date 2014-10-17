class AlterRecommendationColumn < ActiveRecord::Migration
  def change
  	change_column :recommendations_emails, :recommendation, :text
  end
end
