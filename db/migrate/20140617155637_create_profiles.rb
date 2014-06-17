class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :title
      t.string :employee_identifier
      t.binary :photo
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
