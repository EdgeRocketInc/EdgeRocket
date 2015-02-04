
class AddNewCoursesFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :new_courses, :boolean
  end
end
