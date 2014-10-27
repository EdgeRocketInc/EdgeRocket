class ConvertProfilePhoto < ActiveRecord::Migration
  def change
  	profiles = Profile.where("photo is not null")
  	profiles.each { |p|
      image_photo = MiniMagick::Image.read(p.photo)
      image_photo.thumbnail "x200"
      image_photo.format 'png'
      p.photo = image_photo.to_blob
      p.photo_mime_type = 'image/png'
      p.save
  	}
  end
end
