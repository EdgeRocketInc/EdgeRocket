class AddPhotoMimeTypeToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :photo_mime_type, :string
    add_column :profiles, :thumb_mime_type, :string, default: 'image/png'
  end
end
