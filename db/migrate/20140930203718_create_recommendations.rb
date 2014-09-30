class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :skill_id
      t.integer :product_id
      t.timestamps
    end
  end
end
