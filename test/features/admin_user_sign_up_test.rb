require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class AdminUserSignUpTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "admins can sign up users manually and they recieve an email" do

    Capybara.current_driver = :selenium

    @account = create_account
    @user = create_user(@account)
    admin_logs_in
    admin_adds_new_user
  end

  private

  def admin_logs_in
    visit app_path
    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'
    assert_content page, "Propel Your Learning and Success"
  end
  def admin_adds_new_user
    visit '/employees'
    click_button 'Add User'
    fill_in 'newEmplEmail', with: 'testuser@user.com'
    fill_in 'newEmplPassword', with: 'password'
    fill_in 'newEmplFirstName', with: 'User'
    fill_in 'newEmplPassword2', with: 'password'
    select "Standard User", :from => 'selectRole'
    click_on "Create"
    assert_content page, "testuser@user.com"
  end
end