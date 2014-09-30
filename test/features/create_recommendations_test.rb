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

  @user = FactoryGirl.create(:user, :email => 'sysop-test@edgerocket.co', :password => '12345678')
  @role = FactoryGirl.create(:role, :name => 'Sysop', :user_id => @user.id)

  @product1 = FactoryGirl.create(:product, name: 'Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')
  @product2 = FactoryGirl.create(:product, name: 'Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool')
  @product3 = FactoryGirl.create(:product, name: 'Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool')

  @skill1 = FactoryGirl.create(:skill, name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
  @skill2 = FactoryGirl.create(:skill, name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
  @skill3 = FactoryGirl.create(:skill, name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
  @skill4 = FactoryGirl.create(:skill, name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)

  visit root_path

  fill_in 'user_email', with: 'sysop-test@edgerocket.co'
  fill_in 'user_password', with: '12345678'
  click_button 'Sign in'

  visit "/recommendations/index"



  end














end