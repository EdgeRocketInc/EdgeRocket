class AddSchoolToProducts < ActiveRecord::Migration
  def change
    add_column :products, :school, :string
  end
end
