class AddFieldsToMyCourses < ActiveRecord::Migration
  def change
    add_column :my_courses, :status, :string, limit: 20
    add_column :my_courses, :assigned_by, :string, limit: 20
    add_column :my_courses, :completion_date, :datetime
    add_column :my_courses, :percent_complete, :decimal
  end
end
