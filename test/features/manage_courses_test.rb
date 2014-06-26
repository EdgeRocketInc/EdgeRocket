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

  test "List courses and add new" do

    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'admin-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit root_path
    fill_in "user_email", with: 'admin-test@edgerocket.co'
    fill_in "user_password", with: '12345678'
    click_button 'Sign in'

    visit '/products/curated'
    assert_content page, "Course Title"
    assert_content page, "Provider"
    click_button 'Add Item'
    fill_in "newTitle", with: 'New Product Title Test'
    click_button 'Create'

  end
end
