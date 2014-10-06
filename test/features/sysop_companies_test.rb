require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class SysopCompaniesTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "system can view the page and it has records" do

    Capybara.current_driver = :selenium

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/companies"
    assert_content page, "ABC Co."
  end

  test "companies can have nil values in the created_at date field" do

    Capybara.current_driver = :selenium

    @account = create_account
    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    @account.update(:created_at => "")
    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/companies"
    assert_content page, "ABC Co."
  end
end
