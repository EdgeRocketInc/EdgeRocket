# This model contains all kinds of educational materials such as courses, videos, books, and etc.

class Product < ActiveRecord::Base
	has_and_belongs_to_many :playlists
	belongs_to :vendors
end
