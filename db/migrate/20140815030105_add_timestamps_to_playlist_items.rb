class AddTimestampsToPlaylistItems < ActiveRecord::Migration
  def change
    add_column :playlist_items, :created_at, :datetime
    add_column :playlist_items, :updated_at, :datetime
  end
end
