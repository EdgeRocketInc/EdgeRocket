require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'
require 'optparse'
require 'yaml'

class CourseraClient
 	def self.courses
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses?fields=instructor", {:accept => :json}
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
	:adapter => config['database']['adapter'],\
	:database => config['database']['database'],\
	:host => config['database']['host'],\
	:port => config['database']['port'],\
	:username => config['database']['username'],\
	:password => config['database']['password']


courses_json = CourseraClient.courses
skipped = 0

courses_json.each_with_index { |crs, i|
	# construct the course url and then search existing record in the DB
	course_url = 'https://www.coursera.org/course/' + crs['shortName']
	existing_prd = Product.find_by_origin(course_url)
	if existing_prd.nil?
		prd = Product.new
		prd.vendor_id = 1 # Coursera
		prd.name = crs['name']
		prd.authors = crs['instructor']
		prd.origin = course_url
		prd.media_type = 'online'
		prd.manual_entry = false
		prd.save
	else 
		skipped += 1
	end
	if (i % 100) == 0 then print '.' end
}

print "\n"
puts('Processed ' + courses_json.length.to_s + ' records, ' + skipped.to_s + ' skipped ')
