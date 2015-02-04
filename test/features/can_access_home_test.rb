require = require "test_helper"
require
require "database_cleaner"
#require 'byebug'

DatabaseCleaner.strategy = :truncation

class CanAccessHomeTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end

    Capybara.current_driver = :selenium
  end

  teardown do
    DatabaseCleaner.clean
  end

  before do
    @account = create_account
  end

  # test "can complete survey" do
  #
  #   Capybara.current_driver = :selenium
  #
  #   @user = create_user(@account)
  #   @skill = FactoryGirl.create(:skill, :name => 'skill-1', :hpos => 1, :vpos => 1, :key_name => 's1')
  #
  #   visit app_path
  #   fill_in "user_email", with: @user.email
  #   fill_in "user_password", with: @user.password
  #   click_button 'Sign in'
  #
  #   # clear
  #   find("#marketing").click
  #   within(".modal-footer") {click_button "Submit"}
  #
  #   # TODO: figure out why this test fails intermittently and then uncomment it
  #   within(".modal-footer") {assert_content page,"Thanks! Based on your preferences,"}
  # end

  test "all user pages sanity" do

    @user = create_user(@account)
    visit app_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button 'Sign in'

    assert_content page, "Welcome to EdgeRocket"

    visit '/my_courses'
    assert_content page, "My Courses"
    assert_content page, "My Playlists"

    visit '/search'
    assert_content page, "Advanced search"

    visit '/plans'
    assert_content page, "No Plans"

    visit '/welcome/edit_password'
    assert_content page, "Change Password"

    visit '/profile'
    assert_content page, "User profile"
    click_button 'Save Changes'
    assert_content page, "Profile changed successfully"

    visit '/company'
    assert_content page, "welcome"
    click_button 'Save Changes'
    assert_content page, "welcome"

    # The snap-ci did not execute it
    #assert_content page, "Test if CI can fail on this"

  end


  test "all admin pages sanity" do

    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit app_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button 'Sign in'

    visit '/dashboard'
    assert_content page, "Total Users"
    assert_content page, "Admin Users"
    assert_content page, "Standard Users"

  end

  test "users can only login if their company is active" do

    # skip # it fails on the last assert

    @other_account = FactoryGirl.create(:account, :company_name => 'other', :disabled => true, options: "{\"budget_management\":true,\"survey\":true,\"discussions\":\"gplus\",\"recommendations\":true,\"dashboard_demo\":true}")
    @user = create_user(@other_account)
    @role = FactoryGirl.create(:role, :name => 'Admin', :user_id => @user.id)

    visit app_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    click_button 'Sign in'
    assert_content page, "Invalid email or password."

  end


end
