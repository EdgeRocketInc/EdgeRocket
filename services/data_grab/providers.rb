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
