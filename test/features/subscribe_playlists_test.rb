require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class ManageCoursesTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "Subscribe to a playlist" do

    Capybara.current_driver = :selenium

    @account = FactoryGirl.create(:account, :company_name => 'ABC Co.')
    @user = FactoryGirl.create(:user, :email => 'admin-test@edgerocket.co', :password => '12345678', :account_id => @account.id)
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit root_path
    fill_in "user_email", with: 'admin-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
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
