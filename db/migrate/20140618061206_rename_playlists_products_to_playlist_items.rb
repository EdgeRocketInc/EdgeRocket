class RenamePlaylistsProductsToPlaylistItems < ActiveRecord::Migration
  def change
	rename_table :playlists_products, :playlist_items
	add_column :playlist_items, :id, :primary_key
    add_column :playlist_items, :rank, :integer
  end
end
