class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :title
      t.boolean :mandatory

      t.timestamps
    end
  end
end
