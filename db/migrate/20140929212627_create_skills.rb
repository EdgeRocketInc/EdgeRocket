class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :vpos
      t.integer :hpos

      t.timestamps
    end
  end
end
