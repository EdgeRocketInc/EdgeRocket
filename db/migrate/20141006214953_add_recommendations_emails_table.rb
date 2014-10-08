class AddRecommendationsEmailsTable < ActiveRecord::Migration
  def change
    create_table :recommendations_emails do |t|
      t.integer :user_id
      t.integer :skill_id
      t.integer :product_id
      t.timestamps
    end
  end
end
