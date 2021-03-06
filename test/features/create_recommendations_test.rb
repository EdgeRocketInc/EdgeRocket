require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class CreateRecommendationsTest < Capybara::Rails::TestCase
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

  test "sysop user can visit recommendations index " do

    @account = create_account
    @user = create_user(@account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    @product1 = FactoryGirl.create(:product, name: 'Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')
    @product2 = FactoryGirl.create(:product, name: 'Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool')
    @product3 = FactoryGirl.create(:product, name: 'Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool')

    # moved skills to fixtures now

    @recommendation1 = FactoryGirl.create(:recommendation, product_id: @product1.id, skill_id: 1)
    @recommendation2 = FactoryGirl.create(:recommendation, product_id: @product2.id, skill_id: 1)
    @recommendation3 = FactoryGirl.create(:recommendation, product_id: @product3.id, skill_id: 2)

    visit app_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/recommendations"

    click_on "Marketing"

    assert_content page, "Test Product One"
    assert_content page, "Test Product Two"

    click_on "Social Media Marketing"

    assert_content page, "Test Product Three"
    assert_no_content page, "Test Product One"
  end

  test "Sysop user can associate skills and products" do

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    @product1 = FactoryGirl.create(:product, name: 'A A Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')

    visit app_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/recommendations"

    click_on "Computer Science"
    click_on "Add Item"
    # The test fails without sleep, is there another way to fix it w/o sleep?
    sleep(0.2)
    first(".product-recommendation").click

    click_on "Add to Recommended"
    sleep(0.2)

    assert_content page, "A A Test Product One"

  end


  test "Sysop user can delete an existing course recommendation" do

    account = create_account
    @user = create_user(account)
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    @product1 = FactoryGirl.create(:product, name: 'A A Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')
    @product2 = FactoryGirl.create(:product, name: 'AAA Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool')
    @product3 = FactoryGirl.create(:product, name: 'AAA Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool')

    @recommendation1 = FactoryGirl.create(:recommendation, product_id: @product1.id, skill_id: 1) #@skill1.id)
    @recommendation2 = FactoryGirl.create(:recommendation, product_id: @product2.id, skill_id: 1) #@skill1.id)
    @recommendation3 = FactoryGirl.create(:recommendation, product_id: @product3.id, skill_id: 3) #@skill2.id)

    visit app_path

    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'

    visit "/system/recommendations"

    sleep 0.5
    click_on "Marketing"
    sleep 0.5
    first(".glyphicon-trash").click

    assert_no_content page, "A A Test Product One"
    assert_content page, "AAA Test Product Two"

  end

end