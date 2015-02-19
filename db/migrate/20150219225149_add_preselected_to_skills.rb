class AddPreselectedToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :preselected, :boolean, default: false, null: false
  end
end
