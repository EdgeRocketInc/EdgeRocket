require 'cgi' # CGI for HTTP requests
require 'nokogiri'

# Course Providers

class ProviderClient

  attr_accessor :vendor_id
  attr_accessor :json_data
  attr_accessor :one_price

  def initialize(vendor_id, json_file, price = nil)
  	self.vendor_id = vendor_id
  	self.one_price = price
  	# read json data if it's provided
	if !json_file.nil? 
		io = IO.read(json_file)
		self.json_data = JSON.parse( io )
	end
  end

  def origin(row)
    raise "Abstract method called"
  end

  def name(row)
    raise "Abstract method called"
  end

  def description(row)
    raise "Abstract method called"
  end

  def price(row)
    raise "Abstract method called"
  end

  def authors(row)
    raise "Abstract method called"
  end

  def courses
    raise "Abstract method called"
  end

  def instructors
    raise "Abstract method called"
  end

  def school
    raise "Abstract method called"
  end

end

# using Coursera API
class CourseraClient < ProviderClient

	def origin(row)
		course_url = 'https://www.coursera.org/course/' + row['shortName']
	end

	def name(row)
		row['name']
	end

  def description(row)
		row['shortDescription']
    end

    def price(row)
    	nil
 	end

	def authors(row)
		row['instructor']
	end

 	def courses
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses?fields=instructor,shortDescription&includes=instructors", {:accept => :json}
		courses_json = JSON.parse(courses)
		courses_json['elements']		
 	end

 	def instructors
		instructors = RestClient.get "https://api.coursera.org/api/catalog.v1/instructors", {:accept => :json}
		instructors_json = JSON.parse(instructors)
		instructors_json['elements']		
 	end

  def school(row)
    nil
  end

end

# using Udemy API
# Approach:
#   1. obtain courses using Linkshare API with these keywords 
#      "accounting excel design hire hiring marketing java php project sales security sql user"
#   2. Use Udemy API for each course link
class UdemyClient < ProviderClient

  def origin(row)
    course_url = row['linkshare_url'].text
  end

  def name(row)
    row['title']
  end

  def description(row)
    row['headline']
  end

  def price(row)
    row['price'].nil? ? nil : row['price'].to_i
  end

  def authors(row)
    if !row['visibleInstructors'].nil? && row['visibleInstructors'].length > 0
      row['visibleInstructors'][0]['title']
    end
  end

  def courses
    courses = []
    # get Linkshare published links
    query_keywords = CGI::escape('accounting excel design hire hiring marketing java php project sales security sql user')
    query_body = 'http://productsearch.linksynergy.com/productsearch?token=75e4b687b013d1b0480bc5fd0a56ef163ea3bc436ce45a7b6d4e60bff9fe3be9&max=100&mid=39197&keyword=&one='
    query_body += query_keywords
    pagenumber = 0
    total_pages = 0
    begin
      pagenumber += 1
      puts 'Retrieving page #' + pagenumber.to_s
      linkshare_query = query_body + '&pagenumber=' 
      linkshare_query += pagenumber.to_s
      linkshare_links = RestClient.get linkshare_query, {:accept => :xml}
      xml_result = Nokogiri::XML(linkshare_links)
      links_xml = xml_result.xpath('//linkurl')
      uri_parser = URI::Parser.new
      links_xml.each { |ls_link|
        # extarct course ID from each link
        uri = uri_parser.parse(ls_link.text)
        murl = CGI::parse(uri.query)['murl']
        course_key = murl[0].split('/')[3]
        a_course = get_course(course_key)
        a_course['linkshare_url'] = ls_link
        courses << a_course
      }
      # figure out if need to process more pages
      total_pages_xml = xml_result.xpath('//TotalPages')
      total_pages = total_pages_xml.text.to_i
      #byebug
    end while pagenumber < total_pages
    courses
  end

  def instructors
    nil
  end

  def school(row)
    nil
  end

  private 

  def get_course(course_key)
      course = RestClient.get "https://www.udemy.com/api-1.1/courses/" + course_key, {
        :accept => :json,
        'X-Udemy-Client-Id' => '11daeeadaa86d763fc5473331d53467a',
        'X-Udemy-Client-Secret' => '55c0457db708856c8c9f238eeca7b422cfa11a8f'
      }
      course_json = JSON.parse(course)
  end

end


# Using scraped data passed as JSON
class JsonClient < ProviderClient

	def origin(row)
		row['origin'][0]
	end

	def name(row)
		row['name'][0]
	end

    def description(row)
		row['description'].nil? ? nil : row['description'][0]
    end

    def price(row)
    	one_price
 	end

	def authors(row)
		row['authors'].nil? ? nil : row['authors'][0]
	end

	def courses
		json_data['data']
	end

	def instructors
		nil
	end

  def school(row)
    row['school'][0]
  end

end
