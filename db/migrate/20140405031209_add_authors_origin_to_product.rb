class AddAuthorsOriginToProduct < ActiveRecord::Migration
  def change
    add_column :products, :authors, :string
    add_column :products, :origin, :string
    add_column :products, :price, :decimal, :precision => 8, :scale => 2
   end
end
