class AddAccountIdToProduct < ActiveRecord::Migration
  def change
    add_column :products, :account_id, :integer
    add_index :products, :account_id
  end
end
