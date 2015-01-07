require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class PendingUserTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test 'encrypt_password' do

    Capybara.current_driver = :selenium

    account = create_account

    password = "password"
    pending_user = PendingUser.new(
      first_name: 'Admin',
      last_name: 'Test',
      email: 'admin-test@edgerocket.co',
      encrypted_password: password,
    )
    pending_user.save

    user = User.create!(
      email: pending_user.email,
      password: 'dumbpass',
      account: account
    )
    user.update_column(:encrypted_password, pending_user.encrypted_password)

    visit app_path
    fill_in "user_email", with: 'admin-test@edgerocket.co'
    fill_in "user_password", with: 'password'
    click_button 'Sign in'

    assert_content page, "Welcome to EdgeRocket"

  end

end

