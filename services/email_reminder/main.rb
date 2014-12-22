#!/usr/bin/ruby
# main script for pulling catalog data from multiple providers

require 'rubygems' 
require 'bundler/setup' 

require 'rest_client'
require 'active_record'
require 'logger'
require 'syslog/logger'
require 'optparse'
require 'yaml'
require 'sendgrid-ruby'

require 'byebug'

require_relative '../models/user'

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

email_client = SendGrid::Client.new(api_user: 'edgerocket', api_key: '}V^{J)af>p7<')
header = Smtpapi::Header.new
filter = {
  'templates' => {
    'settings' => {
      'enable' => 1,
      'template_id' => 'ecb8f0c9-6877-466d-96b3-a9c717e69827'
    }
  }
}
header.set_filters(filter)

users = User.all_incomplete()

users.each { |u|
	logger.info('Sending email to: ' + u.email)
	# send a templated email via SG
	email = SendGrid::Mail.new do |m|
	  m.to      = u.email
	  m.from    = 'support@edgerocket.co'
	  m.subject = ' '
	  m.html    = ' '
	  m.text    = ' '
	  m.smtpapi = header
	end

	email_client.send(email)
}

logger.info('DONE ' + users.count.to_s)
