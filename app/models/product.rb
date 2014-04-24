# This model contains all kinds of educational materials such as courses, videos, books, and etc.

class Product < ActiveRecord::Base
	has_and_belongs_to_many :playlists
	belongs_to :vendor
	has_many :my_courses

  # search courses (aka prodcuts) with a filter, and include the vendor fields
  # in the result
  def self.search_courses(filter)
    # TODO make it right with the eager loading or something like that
    self.connection.select_all('select p.id, p.name as pname, p.authors, p.origin, p.price, v.name as vname, v.logo_file_name, p.keywords, p.school from products p left join vendors v on p.vendor_id=v.id order by p.name')
  end
end
