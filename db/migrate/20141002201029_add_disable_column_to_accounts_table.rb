class AddDisableColumnToAccountsTable < ActiveRecord::Migration
  def change
    add_column :accounts, :disabled, :boolean, :default=>false
  end
end
