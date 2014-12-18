#!/usr/bin/ruby
# main script for pulling catalog data from multiple providers

require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'
require 'optparse'
require 'yaml'
require 'byebug'

class Product < ActiveRecord::Base
end

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
