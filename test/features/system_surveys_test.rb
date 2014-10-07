require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class SystemSurveysTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end


  test "sysop user can view and mark surveys as processed/unprocessed" do
    Capybara.current_driver = :selenium

    account = create_account
    @user = create_user(account)
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

  test "sysop user can view the processed surveys modal" do
    Capybara.current_driver = :selenium

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    @survey = FactoryGirl.create(:survey, :preferences => "{\"skills\":[{\"id\":\"cs\"},{\"id\":\"soft_dev_methods\"},{\"id\":\"communications\"},{\"id\":\"hiring\"},{\"id\":\"strategy\"},{\"id\":\"ops\"},{\"id\":\"pmp\"},{\"other_skill\":\"test 12 test 34\"}]}", :user_id => @user.id, :created_at => Date.new(2014,12,15))

    # these skills are created in fixtures
    #Skill.create(name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
    #Skill.create(name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)
    #Skill.create(name: 'Communications', key_name: 'communications', vpos: 4, hpos: 1)

    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'
    visit "/system/surveys"

    find(".glyphicon-new-window").click
    assert_equal find("#other-skill").value, "test 12 test 34"

    within(".modal-body") {assert_equal page.find("#marketing").checked?, false}
    within(".modal-body") {assert_equal find("#cs").checked?, true}
    within(".modal-body") {assert_equal find("#communications").checked?, true}

  end

end