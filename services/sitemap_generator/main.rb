#!/usr/bin/ruby
# main script for pulling catalog data from multiple providers

require 'rubygems' 
require 'bundler/setup' 

require 'active_record'
require 'logger'
require 'syslog/logger'
require 'optparse'
require 'yaml'
require 'nokogiri'

require_relative '../models/product'

logger = Logger.new(STDOUT)
#logger = Syslog::Logger.new()
logger.level = Logger::INFO

options = {:config => nil}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-c', '--config config', 'Config file (required)') do |config|
    options[:config] = config
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end.parse!

if options[:config].nil?
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

products = Product.where("account_id is null")

builder = Nokogiri::XML::Builder.new do |xml|
	xml.root {
		products.each { |p|
			#logger.info('Product ID ' + p.id.to_s)	
			xml.url {
				xml.loc 'https://edgerocket.co/public/products/' + p.id.to_s + '/'
				xml.lastmod '2015-02-16'
			}
  		}
	}
end

puts builder.to_xml

#logger.info('DONE ' + products.count.to_s)
