class CreatePendingUser < ActiveRecord::Migration
  def change
    create_table :pending_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :email
      t.string :encrypted_password
    end
  end
end
