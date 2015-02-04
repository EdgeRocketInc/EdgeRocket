class AddRatingToMyCourse < ActiveRecord::Migration
  def change
    add_column :my_courses, :my_rating, :decimal
    add_column :products, :avg_rating, :decimal
  end
end
