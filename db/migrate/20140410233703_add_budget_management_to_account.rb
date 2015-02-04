class AddBudgetManagementToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :budget_management, :boolean
  end
end
