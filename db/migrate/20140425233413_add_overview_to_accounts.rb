class AddOverviewToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :overview, :text
  end
end
