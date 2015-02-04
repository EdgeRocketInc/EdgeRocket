require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class SubscribePlaylistsTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end

    Capybara.current_driver = :selenium
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "Subscribe to a playlist" do

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit app_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button 'Sign in'

    # Add a playlits to use it later
    visit '/playlists'
    assert_content page, "Mandatory"
    click_button 'Add Playlist'
    fill_in "newTitle", with: 'New Playlist Title Test'
    click_button 'Create'

    # subscribe this user to the new playlist
    visit '/user_home'
    # TODO figure out how to do this
    #click_link 'New Playlist Title Test'

    # add a course after subscribing  
    visit '/products/curated'
    assert_content page, "Course Title"
    assert_content page, "Provider"
    click_button 'Add Item'
    fill_in "newTitle", with: 'New Product Title Test'
    select "New Playlist Title Test", :from => 'selectPlaylists'
    click_button 'Create'
    assert_content page, 'New Product Title Test'
    #sleep 1000

    # TODO the new course should be under assigned courses now

  end

end
