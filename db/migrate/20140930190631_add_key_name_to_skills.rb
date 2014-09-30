class AddKeyNameToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :key_name, :string
  end
end
