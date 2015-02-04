require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class ManageUsersTest < Capybara::Rails::TestCase
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

  test "List users and add new" do
    
    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit app_path

    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button 'Sign in'

    # Add a user to use it later
    visit '/employees'
    assert_content page, "Email"
    click_button 'Add User'
    fill_in "newEmplEmail", with: 'test-user-auto-1@edgerocket.co'
    fill_in "newEmplPassword", with: 'abcd1234'
    fill_in "newEmplPassword2", with: 'abcd1234'
    select "Administrator", :from => 'selectRole'
    click_button 'Create'
    assert_content page, 'test-user-auto-1@edgerocket.co'

  end
  
end
