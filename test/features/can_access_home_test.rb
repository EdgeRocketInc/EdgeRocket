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

  test "can complete survey" do

    Capybara.current_driver = :selenium

    @account = FactoryGirl.create(:account, :company_name => 'ABC Co.', options: "{\"budget_management\":true,\"survey\":true,\"discussions\":\"gplus\",\"recommendations\":true,\"dashboard_demo\":true}")
    @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678', :account_id => @account.id)

    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    within(".modal-footer") {click_button "Submit"}
    within(".modal-footer") {assert_content page,"Thanks! Based on your preferences,"}
  end

  test "all user pages sanity" do

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

    visit '/plans'
    assert_content page, "No Plans"

    visit '/welcome/edit_password'
    assert_content page, "Change Password"

    visit '/profile/current'
    assert_content page, "User profile"
    click_button 'Save Changes'
    assert_content page, "Profile changed successfully"

    visit '/company'
    assert_content page, "welcome"
    click_button 'Save Changes'
    assert_content page, "welcome"

    # The snap-ci did not execute it
    #assert_content page, "Test if CI can fail on this"

  end


  test "all admin pages sanity" do

    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'admin-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit root_path
    fill_in "user_email", with: 'admin-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    visit '/dashboard'
    assert_content page, "Total Users"
    assert_content page, "Admin Users"
    assert_content page, "Standard Users"

  end


end
