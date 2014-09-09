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


  test "sysop user can view and mark surveys as processed/unprocessed" do
    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    @survey = FactoryGirl.create(:survey, :preferences => "quote", :user_id => @user.id, :created_at => Date.new(2014,12,15))


    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/surveys"
    find(".glyphicon-check").click
    within(".ngRow") {assert_content page, "sysop-test@edgerocket.co"}
    find(".glyphicon-repeat").click
    within(".ngRow") {assert_content page, "sysop-test@edgerocket.co"}
    find(".glyphicon-check")
  end

end