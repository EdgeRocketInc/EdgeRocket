require_relative 'coursera_helper_methods'

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
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses?fields=instructor,shortDescription,estimatedClassWorkload&includes=instructors,sessions,universities", {:accept => :json}
		courses_json = JSON.parse(courses)    
    
    # retrive the list of universities to lookup as school feild later
    all_schools = RestClient.get "https://api.coursera.org/api/catalog.v1/universities?fields=name", {:accept => :json}
    @all_schools = JSON.parse(all_schools)['elements']
    
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
    s = nil
    if row["links"] && row["links"]["universities"] # for COURSERA API
      school_id = row["links"]["universities"][0]
      s_obj = @all_schools.find {|u| u['id'] == school_id }
      s = s_obj['name'] if !s_obj.nil?
    end
    return s
  end

  # combines estimated workload/week (in hours) for a course with estimated weeks for all the sessions to set duration
  def duration(row)
    d = nil
    if row["links"] && row["links"]["sessions"] # for COURSERA API
      session_ids = row["links"]["sessions"].join(",")
      sessions_json = sessions(session_ids)
      estimated_workload = calculate_workload(row)
      total_length = get_session_weeks(sessions_json)
      d = calculate_duration(estimated_workload, total_length)
    end
    return d
  end

end
