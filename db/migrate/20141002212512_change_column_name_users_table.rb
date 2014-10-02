class ChangeColumnNameUsersTable < ActiveRecord::Migration
  def change
    remove_column :users, :disabled

    add_column :users, :is_active, :boolean, :default=>true
  end
end
