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
    query_keywords = CGI::escape(  # TEST 'javascript')
      'accounting excel design hire hiring marketing java php project sales security sql user harassment'\
      + ' node javascript html css ip intellectual property startups bootstrap sigma tcp webrtc hacking linux legal'\
      + ' cloud photoshop leader job resume career stress goal motivation bitcoin currency')
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
        if !a_course.nil?
          a_course['linkshare_url'] = ls_link
          courses << a_course
        end
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
    row['owner'].nil? ? nil : row['owner']['title']
  end

  def duration(row)
    d = nil
    if row["contentInfo"] #for UDEMY API
      d = row["contentInfo"].split(" ")[0]
    end
    return d
  end

  private 

  def get_course(course_key)
      course_json = nil
      begin
        course = RestClient.get "https://www.udemy.com/api-1.1/courses/" + course_key, {
          :accept => :json,
          'X-Udemy-Client-Id' => '11daeeadaa86d763fc5473331d53467a',
          'X-Udemy-Client-Secret' => '55c0457db708856c8c9f238eeca7b422cfa11a8f'
        }
        course_json = JSON.parse(course)
      rescue RestClient::ResourceNotFound => e
        puts "Error when getting details for: " + course_key
        course_json = nil
      end
  end

end
