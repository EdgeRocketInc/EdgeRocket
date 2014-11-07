# This model contains all kinds of educational materials such as courses, videos, books, and etc.

class Product < ActiveRecord::Base
  has_many :playlist_items, dependent: :restrict_with_error
  has_many :playlists, through: :playlist_items
	has_many :my_courses, dependent: :restrict_with_error
  has_many :discussions, dependent: :restrict_with_error
  has_many :recommendations
  belongs_to :vendor
  belongs_to :account
  belongs_to :skill

  # count courses that would be returned by search with the same parameters 
  def self.count_courses(account_id, media_types, search_query, providers, price)
    self.search_or_count(true, account_id, nil, nil, media_types, search_query, providers, price)
  end

  # search courses (aka products) with a filter, and include the vendor fields
  # in the result
  def self.search_courses(account_id, limit, offset, media_types, search_query, providers, price)
    #byebug
    self.search_or_count(false, account_id, limit, offset, media_types, search_query, providers, price)
  end

  # synchronize (update) avg rating for the given product
  def self.sync_rating(product_id)
    # TODO do we need to sanitize SQL here?
    sql = "update products set avg_rating = (select avg(my_rating) from my_courses where product_id=" \
    	+ product_id.to_s + ") where id=" + product_id.to_s

    result = ActiveRecord::Base.connection.execute(sql)

  end

private

  # used by search and count methods above
  # if media_type is nil, it mean any media type, if it's an empty string, it means none
  def self.search_or_count(is_count, account_id, limit, offset, media_types, search_query, providers, price)
    filter = nil
    # add single quotes around each media type in the comma-separated list
    if !media_types.blank?
      filter = media_types.split(',').inject { |p,q| q = q + "','" + p }
      filter = "'" + filter + "'"
    end
    # TODO make it right with the eager loading or something like that
    statement = is_count ? "count (p.id)" : 'p.id, p.name as pname, p.authors, p.origin, p.price, v.name as vname, v.logo_file_name, ' \
      + 'p.keywords, p.school, p.avg_rating, p.media_type '
    sql_query =
      'select ' + statement \
      + 'from products p left join vendors v on p.vendor_id=v.id ' \
      + 'where (p.account_id is null'
    if !account_id.nil?
      sql_query += ' or p.account_id=' + account_id.to_s + ')'
    else 
      sql_query += ')'
    end
    if !filter.nil?
      sql_query += ' and media_type in (' + filter + ') '
    elsif !media_types.nil? && media_types.empty?
      # empty media means none
      sql_query += ' and media_type is null '      
    end
    sql_query += price_condition(price) if !price.nil?
    if !providers.nil?
      sql_query += ' and vendor_id in (' + providers + ') '
    elsif !providers.nil? && providers.empty?
      # empty providers param means none
      sql_query += ' and vendor_id is null '      
    end
    if !search_query.nil?
      sql_query += " and to_tsvector('english',coalesce(p.name,'')||' '||coalesce(p.description,'')||' '||coalesce(p.authors,'')||' '||coalesce(p.keywords,'')||' '||coalesce(p.school,'')) @@ plainto_tsquery('english',?) "
    end
    if !is_count
      sql_query += ' order by p.manual_entry desc, p.name'
    end
    if !offset.nil? 
      sql_query += ' offset ' + offset.to_s 
    end
    if !limit.nil?
      sql_query += ' limit ' + limit.to_s
    end
    sanitized_sql = self.sanitize_sql_array([sql_query, search_query])
    # avoid syntax errors especially possible in full text search
    begin
      self.connection.select_all(sanitized_sql)
    rescue ActiveRecord::StatementInvalid => e
      # TODO: consider retrying it with reparsed query
      nil
    end
  end

  # price is a string with list of comma separated parameters such as 0,lt50,gte50
  def self.price_condition(price)
    price_map = {
      '0' => 'price is null or price=0',
      'lt50' => 'price < 50',
      'gte50' => 'price >= 50'
    }
    #byebug
    if !price.nil?
      if price.empty?
        return ' and true=false '
      else
        result = ''
        price_params = price.split(',')
        price_params.each { |pp|
          pm = price_map[pp]
          if !pm.blank?
            if result.blank?
              result = ' and ('
            else
              result += ' or '
            end
            result += pm
          end
        }
        if !result.blank?
          result += ' ) '
        end
        return result
      end
    end
  end

end
