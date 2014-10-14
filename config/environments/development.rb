
# Keen IO - dev project
ENV["KEEN_PROJECT_ID"]='5359f352ce5e431e8400001b'
ENV['KEEN_WRITE_KEY']='e601c128f0ecc2b72613a9e82aeb90f9c77898fcb211cc46f5e43d98e53d6774f55884b9dd3372e9ab38d041ff597d50214ee772746c96afc61c5706bdb914ffe0d44b34a2906f1a19578b06f14f6d5e5d849601337f552f8bde9ca757f12cdcd34c94c918df5f2ee153f72e382b6051'
ENV['KEEN_READ_KEY']='7d8e98cc2c3ca9b409ff00f75386a50ad22951ca8f780a25915790778b0fa26cd08fa589a6871dbb646a34331b6c7da7d89b50cd11b084d35854d1e0fc005d64a1deb35d22b23bb1a60662dcce35c90337a75771ec79b85d95af77d4de2dd64e3506ca16d704648623087eccaaea6131'

EdgeApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # this is for Devise
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Disable request forgery protection in development environment.
  # DO NOT COMMIT set to false
  config.action_controller.allow_forgery_protection = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
end
