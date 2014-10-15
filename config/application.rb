require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)


module EdgeApp

  VERSION = '0.1.59'

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # need for Twitter bootstrap and AngularJS
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.assets.precompile += %w(yeti.js yeti.css) # Replace Bootswatch theme here
    config.assets.precompile += %w(profile.js user_home.js angular.js angular-sanitize.js angular-resource.js angular-charts.min.js d3.js search.js dashboards.js ui-bootstrap-tpls-0.11.0.min.js ng-grid-2.0.11.min.js my_courses.js playlists.js teams.js employees.js products.js profile.js welcome.js company.js pending_users.js system.js recommendations.js)
    config.assets.compile = true

    # need for Devise
    config.assets.initialize_on_precompile = false

    # less-rails gem (default all generators)
    config.app_generators.stylesheet_engine :less

    # Required for CleanPagination gem
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :methods => [:get, :options],
          :expose => ['Content-Range', 'Accept-Ranges']
      end
    end

  end
end
