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
    fill_in "pending_user_first_name", with: 'jim'
    fill_in "pending_user_last_name", with: 'kim'
    fill_in "pending_user_email", with: 'miji@kim'
    fill_in "pending_user_encrypted_password", with: 'miji'
    fill_in "pending_user_confirm_password", with: 'miji'
    fill_in "pending_user_company_name", with: 'the mij'
    click_button 'Sign up'

    assert_content page, "Thank you for your interest. We will contact you shortly."
  end

end
