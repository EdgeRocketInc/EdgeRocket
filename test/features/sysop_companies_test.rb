require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class ManageCompaniesTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "system can view the page and it has records" do
    
    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    @account = FactoryGirl.create(:account, :company_name => 'ABC Co.', options: "{\"budget_management\":true,\"survey\":true,\"discussions\":\"gplus\",\"recommendations\":true,\"dashboard_demo\":true}")
    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/companies"
    assert_content page, "ABC Co."
  end
end
