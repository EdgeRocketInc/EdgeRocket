class PlaylistItem < ActiveRecord::Base
	belongs_to :product
	belongs_to :playlist
end
