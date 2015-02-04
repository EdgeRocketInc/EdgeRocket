class AddManualEntryToProduct < ActiveRecord::Migration
  def change
    add_column :products, :manual_entry, :boolean, default: true
    add_column :products, :price_free, :boolean, default: false

  	# update all free price values
	Product.where("price is null or price=0").update_all(:price_free => true)

    add_index :products, :name
  end
end
