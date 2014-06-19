# This model contains all kinds of educational materials such as courses, videos, books, and etc.

class Product < ActiveRecord::Base
  has_many :playlist_items
  has_many :playlists, through: :playlist_items
	belongs_to :vendor
	has_many :my_courses
  has_many :discussions

  # search courses (aka prodcuts) with a filter, and include the vendor fields
  # in the result
  def self.search_courses(filter)
    # TODO make it right with the eager loading or something like that
    self.connection.select_all(
      'select p.id, p.name as pname, p.authors, p.origin, p.price, v.name as vname, v.logo_file_name, ' \
      + 'p.keywords, p.school, p.avg_rating, p.media_type ' \
      + 'from products p left join vendors v on p.vendor_id=v.id order by p.name')
  end

  # synchronize (update) avg rating for the given product
  def self.sync_rating(product_id)
    # TODO do we need to sanitize SQL here?
    sql = "update products set avg_rating = (select avg(my_rating) from my_courses where product_id=" \
    	+ product_id.to_s + ") where id=" + product_id.to_s

    result = ActiveRecord::Base.connection.execute(sql)

  end

end
