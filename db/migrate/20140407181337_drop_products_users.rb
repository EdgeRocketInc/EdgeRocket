class DropProductsUsers < ActiveRecord::Migration
  def change
    drop_table :products_users
  end
end
