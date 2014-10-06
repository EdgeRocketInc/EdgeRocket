class Account < ActiveRecord::Base
  has_many :users
  has_many :playlists
  has_many :products

end
