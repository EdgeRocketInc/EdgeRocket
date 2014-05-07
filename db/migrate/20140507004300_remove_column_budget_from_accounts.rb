class RemoveColumnBudgetFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :budget_management, :string
    add_column :accounts, :options, :text
  end
end
