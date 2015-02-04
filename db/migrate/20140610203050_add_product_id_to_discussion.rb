class AddProductIdToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :product_id, :integer
  end
end
