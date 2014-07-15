require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'
require 'optparse'
require 'yaml'
require 'byebug'

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
    raise "Abstract method called"
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
		courses = RestClient.get "https://api.coursera.org/api/catalog.v1/courses?fields=instructor,shortDescription&includes=instructors", {:accept => :json}
		courses_json = JSON.parse(courses)
		courses_json['elements']		
 	end

 	def instructors
		instructors = RestClient.get "https://api.coursera.org/api/catalog.v1/instructors", {:accept => :json}
		instructors_json = JSON.parse(instructors)
		instructors_json['elements']		
 	end
end

# Using scraped data passed as JSON
class JsonClient < ProviderClient

	def origin(row)
		row['origin'][0]
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
		row['authors'].nil? ? nil : row['authors'][0]
	end

	def courses
		json_data['data']
	end

	def instructors
		nil
	end
end

class Product < ActiveRecord::Base
end

# it maps providers according to the value in vendors table
providers = [
	{ vendor_id: 1, provider_class: CourseraClient, price: nil },
	{ vendor_id: 9, provider_class: JsonClient, price: 49 }, # GA
	{ vendor_id: 14, provider_class: JsonClient, price: 25 } # Treehouse
]

options = {:config => nil}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-c', '--config config', 'Config file (required)') do |config|
    options[:config] = config
  end

  opts.on('-p', '--provider provider', 'Provider of data (required)') do |provider|
    options[:provider] = provider
  end

  opts.on('-j', '--json input_file', 'Input File in JSON format') do |json|
    options[:json] = json
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

if options[:config].nil? || options[:provider].nil?
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


# get the right provider class and create its instance
provider = nil
for p in providers
	if p[:vendor_id] == options[:provider].to_i
		provider = p[:provider_class].new(p[:vendor_id], options[:json], p[:price])
		break
	end
end

instructors_json = provider.instructors
courses_json = provider.courses
skipped = 0

courses_json.each_with_index { |crs, i|
	# construct the course url and then search existing record in the DB
	course_url = provider.origin(crs)
	existing_prd = Product.find_by_origin(course_url)
	if existing_prd.nil?
		#byebug
		prd = Product.new
		prd.vendor_id = provider.vendor_id
		prd.name = provider.name(crs) 
		prd.description = provider.description(crs)
		prd.price = provider.price(crs)
		prd.authors = provider.authors(crs) 
		# in some cases, instructors field may be empty, then we need to dig into the assicoated links
		if prd.authors.blank?
			#puts "blank instr, linked instructors=" + crs['links']['instructors'].to_s
			if !crs['links'].blank? && !crs['links']['instructors'].blank?
				# find instructors in the pre-fetched list
				crs['links']['instructors'].each { |linked_instructor|
					instructors_json.each { |instr|
						if instr['id'] == linked_instructor
							#puts "linked instructor " + instr['firstName'] + ' ' + instr['lastName']
							if prd.authors.blank?
								prd.authors = instr['firstName'] + ' ' + instr['lastName']
							else
								prd.authors += ', ' + instr['firstName'] + ' ' + instr['lastName']
							end
						end
					}
				}
			end
		end
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
