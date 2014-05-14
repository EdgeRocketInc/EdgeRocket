require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'

class CourseraClient
 	def self.courses
 		
 	end
end

courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses"

