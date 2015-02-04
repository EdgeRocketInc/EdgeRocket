class AddDisabledColumnToAccoun < ActiveRecord::Migration
  def change
    remove_column :users, :is_active
    add_column :accounts, :disabled, :boolean, default: false
  end
end
