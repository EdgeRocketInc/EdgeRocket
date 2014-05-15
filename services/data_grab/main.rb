require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'

class CourseraClient
 	def self.courses
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses", {:accept => :json}
		courses_json = JSON.parse(courses)
		courses_json['elements']		
 	end
end

class Product < ActiveRecord::Base
end

# Establish our DB connection 
ActiveRecord::Base.establish_connection\
	:adapter => 'sqlite3',\
	:database => '../../web/edge_app/db/development.sqlite3'



courses_json = CourseraClient.courses

for crs in courses_json
	prd = Product.new
	prd.save
	puts crs['name']
end