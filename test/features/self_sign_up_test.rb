require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class SelfSignUpTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end




end
