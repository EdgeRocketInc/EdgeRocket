class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :products

  # this field can be calculated on the fly
  attr_accessor :percent_complete
end
