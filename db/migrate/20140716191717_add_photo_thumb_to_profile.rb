class AddPhotoThumbToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :photo_thumb, :binary
  end
end
