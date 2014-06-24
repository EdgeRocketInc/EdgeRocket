require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class CanAccessHomeTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "all pages sanity" do

    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'test@gmail.com', :password => '12345678')

    visit root_path
    fill_in "user_email", with: 'test@gmail.com'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    assert_content page, "Playlists"

    visit '/my_courses'
    assert_content page, "My Courses"
    assert_content page, "My Playlists"

    visit '/search'
    assert_content page, "Select All"

  end
end
