class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :company_name

      t.timestamps
    end
    add_index :accounts, :company_name, unique: true
  end
end
