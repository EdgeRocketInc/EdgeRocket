class AddTypeToPendingUsers < ActiveRecord::Migration
  def change
    add_column :pending_users, :user_type, :string
  end
end
