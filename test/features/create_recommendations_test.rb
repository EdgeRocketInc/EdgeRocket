require "test_helper"
require "database_cleaner"

DatabaseCleaner.strategy = :truncation

class CreateRecommendationsTest < Capybara::Rails::TestCase
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  test "sysop user can visit recommendations index " do
    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    @product1 = FactoryGirl.create(:product, name: 'Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')
    @product2 = FactoryGirl.create(:product, name: 'Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool')
    @product3 = FactoryGirl.create(:product, name: 'Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool')


    @skill1 = FactoryGirl.create(:skill, name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
    @skill2 = FactoryGirl.create(:skill, name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
    @skill3 = FactoryGirl.create(:skill, name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
    @skill4 = FactoryGirl.create(:skill, name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)

    @recommendation1 = FactoryGirl.create(:recommendation, product_id: @product1.id, skill_id: @skill1.id)
    @recommendation2 = FactoryGirl.create(:recommendation, product_id: @product2.id, skill_id: @skill1.id)
    @recommendation3 = FactoryGirl.create(:recommendation, product_id: @product3.id, skill_id: @skill2.id)

    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
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
    # TODO fix this test

    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    @product1 = FactoryGirl.create(:product, name: 'A A Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')


    @skill1 = FactoryGirl.create(:skill, name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
    @skill2 = FactoryGirl.create(:skill, name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
    @skill3 = FactoryGirl.create(:skill, name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
    @skill4 = FactoryGirl.create(:skill, name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)

    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/recommendations"

    click_on "Computer Science"
    click_on "Add Item"
    sleep(4)
    first(".product-recommendation").click



    click_on "Add to Recommended"

    assert_content page, "A A Test Product One"

  end


  test "Sysop user can delete an existing course recommendation" do
    # TODO fix this test

    Capybara.current_driver = :selenium

    @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678')
    @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

    @product1 = FactoryGirl.create(:product, name: 'A A Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')
    @product2 = FactoryGirl.create(:product, name: 'AAA Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool')
    @product3 = FactoryGirl.create(:product, name: 'AAA Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool')


    @skill1 = FactoryGirl.create(:skill, name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
    @skill2 = FactoryGirl.create(:skill, name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
    @skill3 = FactoryGirl.create(:skill, name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
    @skill4 = FactoryGirl.create(:skill, name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)

    @recommendation1 = FactoryGirl.create(:recommendation, product_id: @product1.id, skill_id: @skill1.id)
    @recommendation2 = FactoryGirl.create(:recommendation, product_id: @product2.id, skill_id: @skill1.id)
    @recommendation3 = FactoryGirl.create(:recommendation, product_id: @product3.id, skill_id: @skill2.id)

    visit root_path

    fill_in 'user_email', with: 'sysop-test@edgerocket.co'
    fill_in 'user_password', with: '12345678'
    click_button 'Sign in'

    visit "/system/recommendations"

    click_on "Marketing"
    first(".glyphicon-trash").click

    assert_no_content page, "A A Test Product One"
    assert_content page, "AAA Test Product Two"

  end

end