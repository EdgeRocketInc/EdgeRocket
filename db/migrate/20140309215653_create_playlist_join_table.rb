class CreatePlaylistJoinTable < ActiveRecord::Migration
  def change
    create_join_table :playlists, :products do |t|
      t.index [:playlist_id, :product_id]
      t.index [:product_id, :playlist_id]
    end
  end
end
