class AddColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :keywords, :text
  end
end
