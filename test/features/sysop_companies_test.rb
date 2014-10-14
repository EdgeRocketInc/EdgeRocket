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

  test "disabled companies have an x glyphicon" do

    Capybara.current_driver = :selenium

    @account = create_account
    @other_account = create_account({disabled: true, company_name: 'Other Company'})
    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    visit root_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/companies"

    page.find('.glyphicon-ban-circle')
  end

  test "enabled companies can be disabled" do

    Account.destroy_all

    Capybara.current_driver = :selenium

    @account = create_account
    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    visit root_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/companies"

    page.find('.glyphicon-remove').click

    page.find('.glyphicon-ban-circle')
    assert_no_selector('.gylphicon-ok')
  end

  test "system administror can view company information" do
    skip
    @account = create_account
    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    visit root_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/companies"
    page.find('.glyphicon-edit').click

    assert_equal find("#company_name").value, @account.company_name
    assert_equal find("#options").value, @account.options
    assert_content("Edit Company")
  end

  test "system adminstrator can edit company information" do
    skip
    @account = create_account
    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)
    visit root_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/companies"
    page.find('.glyphicon-edit').click
    fill_in 'company_name', :with => "Fantastic Company"
    click_on "Save Changes"
  end
end
