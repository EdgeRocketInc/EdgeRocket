require 'cgi' # CGI for HTTP requests
require 'nokogiri'

# for Youtube
require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'


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
    one_price
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

  def school(row)
    raise "Abstract method called"
  end

  def duration(row)
    raise "Abstract method called"
  end

  def media_type
    'online'
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
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses?fields=instructor,shortDescription,estimatedClassWorkload&includes=instructors,sessions", {:accept => :json}
		courses_json = JSON.parse(courses)
		courses_json['elements']		
  end

  def sessions(session_ids)
    session = RestClient.get "https://api.coursera.org/api/catalog.v1/sessions?ids=#{session_ids}&fields=durationString", {:accept => :json}
    session_json = JSON.parse(session)
    session_json['elements']
  end

 	def instructors
		instructors = RestClient.get "https://api.coursera.org/api/catalog.v1/instructors", {:accept => :json}
		instructors_json = JSON.parse(instructors)
		instructors_json['elements']		
 	end

  def school(row)
    nil
  end

  # combines estimated workload/week (in hours) for a course with estimated weeks for all the sessions to set duration
  def duration(row)
    d = nil
    if row["links"] && row["links"]["sessions"] # for COURSERA API
      session_ids = row["links"]["sessions"].join(",")
      sessions_json = provider.sessions(session_ids)
      estimated_workload = calculate_workload(row)
      total_length = get_session_weeks(sessions_json)
      d = calculate_duration(estimated_workload, total_length)
    end
    return d
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
    #query_keywords = CGI::escape('accounting excel design hire hiring marketing java php project sales security sql user harassment node javascript html css ip intellectual property startups bootstrap sigma tcp webrtc hacking linux legal')
    query_keywords = CGI::escape('cloud photoshop leader job resume career stress goal motivation bitcoin currency')
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

  def duration(row)
    d = nil
    if row["contentInfo"] #for UDEMY API
      d = row["contentInfo"].split(" ")[0]
    end
    return d
  end

end


# Using scraped data passed as JSON
class JsonClient < ProviderClient

	def origin(row)
    # if origin field is present, then use it, if not, then it's expected that 
    # a hidden source field was provided by crawler
    if row['origin'].nil?
      row['_pageUrl']
    else
		  row['origin'][0]
    end
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
    aa = row['authors']
		if aa.nil? 
      return nil
    else 
      return aa[0][0..254]
    end
	end

	def courses
		json_data['data']
	end

	def instructors
		nil
	end

  def school(row)
    row['school'].nil? ? nil : row['school'][0]
  end

  def duration(row)
    d = nil
    if row["duration"] # for WEB SCRAPING
      split = row["duration"][0].split(" ")
      if split[1] == "mins"
        prd.duration = split[0].to_f/60
      end
    end
    return d
  end

end


class YoutubeClient < ProviderClient

  # channels to pull
  ALL_CHANNELS = [
    'UCWo4IA01TXzBeGJJKWHOG9g', # HBR 
    'UCGwuxdEeCf0TIA2RbPOj-8g', # Stanford 
    'UCCv1RvQh98t3M9nXVxkn5bw', # Gitomer 
    'UCC69dxCZQB9VURlHQ8wesPA', # Inc
    'UCqeXB2WsPdzcdCdP-bUc52g', # Fast Company
    'UCbmNph6atAoGfqLoCL_duAg' # Talks at Google
  ]

  def initialize(vendor_id, json_file, price = nil)
    super

    # Initialize Google API 
    @client = Google::APIClient.new(
      :application_name => 'EdgeRocket data grab',
      :application_version => '0.1.70'
    )

    # Initialize Google+ API. Note this will make a request to the
    # discovery service every time, so be sure to use serialization
    # in your production code. Check the samples for more details.
    @youtube = @client.discovered_api('youtube', 'v3')

    # Load client secrets from your client_secrets.json.
    client_secrets = Google::APIClient::ClientSecrets.load

    # Run installed application flow. Check the samples for a more
    # complete example that saves the credentials between runs.
    flow = Google::APIClient::InstalledAppFlow.new(
      :client_id => client_secrets.client_id,
      :client_secret => client_secrets.client_secret,
      :scope => ['https://www.googleapis.com/auth/youtube']
    )
    @client.authorization = flow.authorize
  end

  def courses
    
    # will save all courses from multiple calls
    all_courses = []

    #byebug

    for channel in ALL_CHANNELS do
      page_num = 0
      page_token = nil 
      # get multiple pages
      while page_num < 2
        # Make an API to search for a channel
        result = @client.execute(
          :api_method => @youtube.search.list,
          :parameters => {
            'channelId' => channel, 
            'type' => 'video',
            'maxResults' => 50, 
            'part' => 'id,snippet',
            'pageToken' => page_token,
            'order' => 'date'
          }
        )
        if result
          all_courses += result.data['items']
          page_token = result.data['nextPageToken']
          if page_token.blank?
            break
          end
        else
          break
        end
        page_num += 1
      end
    end

    #byebug

    all_courses

  end

  def instructors
    nil
  end

  def origin(row)
    if !row['id'].nil? && !row["id"]["videoId"].nil?
      "https://www.youtube.com/watch?v=" + row["id"]["videoId"]
    else
      # byebug
      puts 'NULL row : ' + row.to_s
    end
  end

  def name(row)
    row["snippet"]["title"]
  end

  def description(row)
    row["snippet"]["description"]
  end

  def price(row)
    0
  end

  def authors(row)
    # TODO need to send a separate request to get contentDetails
    nil
  end

  def school(row)
    nil
  end

  def duration(row)
    # TODO need to send a separate request to get contentDetails
    nil
  end

  def media_type
    'video'
  end

end
