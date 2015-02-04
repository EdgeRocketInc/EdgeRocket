class ChangeColumnInRecommendationsEmailTable < ActiveRecord::Migration
  def change
    add_column :recommendations_emails, :recommendation, :string
    remove_column :recommendations_emails, :product_id
    remove_column :recommendations_emails, :skill_id
  end


end
