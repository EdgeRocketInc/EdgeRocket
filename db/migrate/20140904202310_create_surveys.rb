class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.text :preferences
      t.integer :user_id
      t.boolean :processed, default: false

      t.timestamps
    end
  end
end
