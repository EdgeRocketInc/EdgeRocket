def calculate_workload(course)
  #this is pulling the lower of the range of values. (i.e. 1-3 hrs. per week results in 1)
  duration_string = course["estimatedClassWorkload"]
  duration_string.split("-")[0].to_i
end

def get_session_weeks(sessions_json)
  total = 0
  sessions_json.each do |session_string|
    total += session_string["durationString"].split(" ")[0].to_i
  end
  total
end

def calculate_duration(workload, total_length)
  duration = workload * total_length
  if duration == 0
    duration = nil
  end
  duration
end