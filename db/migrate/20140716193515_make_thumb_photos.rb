class MakeThumbPhotos < ActiveRecord::Migration
  def change
  	profiles = Profile.where('photo is not null and photo_thumb is null')
  	profiles.each { |p|
		image = MiniMagick::Image.read(p.photo)
		image.thumbnail "x45"
		image.format 'png'
		p.photo_thumb = image.to_blob
		p.save
  	}
  end
end
