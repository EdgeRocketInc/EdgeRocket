class DropUserPreferencesColumn < ActiveRecord::Migration
  def change
    remove_column :users, :preferences
  end
end
