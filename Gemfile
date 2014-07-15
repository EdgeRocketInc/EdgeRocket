source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1'

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '1.3.8'
  #gem 'debugger'
  gem 'byebug' # replaces 'debugger'
end

group :test do
  gem 'minitest'
  gem 'minitest-rails-capybara'
  gem 'factory_girl_rails'
  gem 'factory_girl'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
end

group :stage do
  gem 'unicorn'
  gem 'rails_12factor'
end

gem 'pg', '0.17.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.4'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Bootstrap 
gem 'bootstrap-sass', '3.1.0'

# Bootswatch & JS engine for it
gem 'twitter-bootswatch-rails', '~> 3.1.1'
gem 'twitter-bootswatch-rails-helpers', '~> 3.1'
gem 'therubyracer', '~> 0.12'		

# Authentication and Authorization 
gem 'devise', '3.2.4'
gem 'cancancan', '~> 1.7'

# Logging and analytics
#gem 'em-http-request', '~> 1.1' #for async Keen IO events
gem 'keen', '~> 0.8'

# Google API client for Google+ Domain discussions and comments
gem 'google-api-client', '~> 0.7'

# pagination
gem 'clean_pagination', '~> 0.0'
gem 'rack-cors', :require => 'rack/cors'