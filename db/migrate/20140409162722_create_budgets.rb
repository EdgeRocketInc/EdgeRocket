class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :user_id
      t.decimal  "amount_allocated",      precision: 8, scale: 2
      t.decimal  "amount_used",      precision: 8, scale: 2
      t.timestamps
    end
  end
end
