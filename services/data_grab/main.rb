require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'

class CourseraClient
 	def self.courses
 		
 	end
end

courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses", {:accept => :json}
courses_json = JSON.parse(courses)

for crs in courses_json['elements']
	puts crs['name']
end