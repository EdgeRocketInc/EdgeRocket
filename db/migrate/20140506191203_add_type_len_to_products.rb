class AddTypeLenToProducts < ActiveRecord::Migration
  def change
    add_column :products, :media_type, :string, limit: 10
    add_column :products, :duration, :decimal, precision: 8, scale: 2
  end
end
