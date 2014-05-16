require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'
require 'optparse'
require 'yaml'

class CourseraClient
 	def self.courses
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses", {:accept => :json}
		courses_json = JSON.parse(courses)
		courses_json['elements']		
 	end
end

class Product < ActiveRecord::Base
end


options = {:config => nil}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-c', '--config config', 'Config file') do |config|
    options[:config] = config
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

if options[:config] == nil
    puts 'Missing arguments. Use -h for help'
    exit
end

config = YAML.load_file(options[:config])

# Establish our DB connection 
ActiveRecord::Base.establish_connection\
	:adapter => config['database']['adapter'], :database => config['database']['database']

courses_json = CourseraClient.courses

for crs in courses_json
	prd = Product.new
	prd.name = crs['name']
	prd.save
end
