class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_and_belongs_to_many :users

  # this field can be calculated on the fly
  attr_accessor :percent_complete

  def calc_fields
    # TODO make it right
    self.percent_complete = 33.0
  end

end
