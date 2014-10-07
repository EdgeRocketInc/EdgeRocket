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


  # test "sysop user can view and mark surveys as processed/unprocessed" do
  #   Capybara.current_driver = :selenium
  #
  #   account = create_account
  #   @user = create_user(account)
  #   @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
  #   @survey = FactoryGirl.create(:survey, :preferences => "quote", :user_id => @user.id, :created_at => Date.new(2014,12,15))
  #
  #   visit root_path
  #
  #   fill_in 'user_email', with: 'sysop-test@edgerocket.co'
  #   fill_in 'user_password', with: '12345678'
  #   click_button 'Sign in'
  #
  #   visit "/system/surveys"
  #   find(".glyphicon-check").click
  #   within(".ngRow") {assert_content page, "sysop-test@edgerocket.co"}
  #   find(".glyphicon-repeat").click
  #   within(".ngRow") {assert_content page, "sysop-test@edgerocket.co"}
  #   find(".glyphicon-check")
  # end

  # test "sysop user can view the processed surveys modal" do
  #   Capybara.current_driver = :selenium
  #
  #   account = create_account
  #   @user = create_user(account)
  #   @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
  #   @survey = FactoryGirl.create(:survey, :preferences => "{\"skills\":[{\"id\":\"cs\"},{\"id\":\"soft_dev_methods\"},{\"id\":\"communications\"},{\"id\":\"hiring\"},{\"id\":\"strategy\"},{\"id\":\"ops\"},{\"id\":\"pmp\"},{\"other_skill\":\"test 12 test 34\"}]}", :user_id => @user.id, :created_at => Date.new(2014,12,15))
  #
  #   @vendor1 = FactoryGirl.create(:vendor, name: 'Coursera')
  #   @vendor2 = FactoryGirl.create(:vendor, name: 'Youtube')
  #
  #   @product1 = FactoryGirl.create(:product, name: 'Intro to Communications', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool', vendor_id: @vendor1.id)
  #   @product2 = FactoryGirl.create(:product, name: 'Advanced Communications', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool', vendor_id: @vendor2.id)
  #
  #   @skill1 = FactoryGirl.create(:skill, name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
  #   @skill2 = FactoryGirl.create(:skill, name: 'Communications', key_name: 'communications', vpos: 1, hpos: 0)
  #
  #   @recommendation1 = FactoryGirl.create(:recommendation, product_id: @product1.id, skill_id: @skill1.id)
  #   @recommendation2 = FactoryGirl.create(:recommendation, product_id: @product2.id, skill_id: @skill1.id)
  #
  #   visit root_path
  #
  #   fill_in 'user_email', with: 'sysop-test@edgerocket.co'
  #   fill_in 'user_password', with: '12345678'
  #   click_button 'Sign in'
  #   visit "/system/surveys"
  #
  #   find(".glyphicon-new-window").click
  #   assert_equal find("#other-skill").value, "test 12 test 34"
  #
  #   within(".modal-body") {assert_content page, "Communications"}
  #   within(".modal-body") {assert_no_content page, "Marketing"}
  #
  #   within(".modal-body") {assert_content page, "Intro to Communications"}
  #   within(".modal-body") {assert_content page, "Intro to Communications"}
  #
  #
  #
  #
  # end

end