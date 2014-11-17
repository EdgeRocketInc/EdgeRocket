require 'open-uri'

class EdxClient < ProviderClient

  def origin(row)
    row['url']
  end

  def name(row)
    row['l']
  end

  def description(row)
    page = get_course_html(row)
    course = page.css('div.course-detail-subtitle.copy-lead')
    if course.nil? 
      return nil
    else
      !course.text.nil? ? course.text : nil
    end
  end

  def authors(row)
    page = get_course_html(row)
    authors = page.css('h4.staff-title')
    if authors.nil? || authors[0].nil?
      return nil
    else
      # TODO add all authors
      !authors[0].text.nil? ? authors[0].text : nil
    end
  end

  def courses
    # get l;ist of courses via JSON API
    courses = RestClient.get "edx.org/search/api/all", {:accept => :json}
    courses_json = JSON.parse(courses)
  end

  def instructors
    # TODO
    nil
  end

  def school(row)
    row['schools'].join(', ')
  end

  def duration(row)
    d = nil
    return d
  end

private

  # get page from server or use cached one
  def get_course_html(row)
    course_html = nil
    if row['course_html'].nil?
      # add a sleep delay to aoid blocked HTTP requests
      sleep Random.rand(0..10) * 0.01
      begin
        course_html = Nokogiri::HTML(open(origin(row)))
      rescue OpenURI::HTTPError => e
        puts "Error when getting HTML page for: " + origin(row)
      end
      if !course_html.nil? 
        # insert this HTML into the row to use later
        row['course_html'] = course_html
      end
    else
      course_html = row['course_html']
    end
    course_html      
  end

end
