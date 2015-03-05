class AddSynonymsToSkill < ActiveRecord::Migration
  def change
    add_column :skills, :synonyms_json, :text
  end
end
