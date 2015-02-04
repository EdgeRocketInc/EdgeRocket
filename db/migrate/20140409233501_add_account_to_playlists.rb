class AddAccountToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :account_id, :integer
  end
end
