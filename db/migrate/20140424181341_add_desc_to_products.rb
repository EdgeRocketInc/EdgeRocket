class AddDescToProducts < ActiveRecord::Migration
  def change
    add_column :products, :description, :text
  end
end