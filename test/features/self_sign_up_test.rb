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

  test "user can sign up" do

    Capybara.current_driver = :selenium

    visit sign_up_path
    fill_in "pending_user_first_name", with: 'admin'
    fill_in "pending_user_last_name", with: 'test'
    fill_in "pending_user_email", with: 'admin-test@edgerocket.co'
    fill_in "pending_user_encrypted_password", with: 'password'
    fill_in "pending_user_confirm_password", with: 'password'
    fill_in "pending_user_company_name", with: 'Edgerocket'
    click_button 'Sign up'

    assert_content page, "Thank you for your interest. We will contact you shortly."


  end

  test "user sees error messages" do
    Capybara.current_driver = :selenium

    visit sign_up_path
    fill_in "pending_user_first_name", with: ''
    fill_in "pending_user_last_name", with: ''
    fill_in "pending_user_email", with: ''
    fill_in "pending_user_encrypted_password", with: ''
    fill_in "pending_user_confirm_password", with: ''
    fill_in "pending_user_company_name", with: ''
    click_button 'Sign up'

    assert_content page, "First name can't be blank"
    assert_content page, "Last name can't be blank"
  end

end
