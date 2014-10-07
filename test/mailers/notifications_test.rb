require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  before :each do
    @user = User.new
    @user.email = 'test@EdgeRocket.co'
    @user.password = 'password'
    @user.id = 1
    @user.save!

    Survey.create!(
      preferences: '{"skills"=>[{"id"=>"seo"}, {"id"=>"cs"}, {"id"=>"computer_networking"}], "user_home"=>{"skills"=>[{"id"=>"seo"}, {"id"=>"cs"}, {"id"=>"computer_networking"}]}}'.to_json,
      user_id: @user.id
    )
    @vendor1 = FactoryGirl.create(:vendor, name: 'Coursera')
    @vendor2 = FactoryGirl.create(:vendor, name: 'Youtube')
    @vendor3 = FactoryGirl.create(:vendor, name: "Layne's awesome programming school")

    @product1 = FactoryGirl.create(:product, name: 'Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool', vendor_id: @vendor1.id)
    @product2 = FactoryGirl.create(:product, name: 'Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool', vendor_id: @vendor2.id)
    @product3 = FactoryGirl.create(:product, name: 'Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: @vendor3.id)


    @skill1 = FactoryGirl.create(:skill, name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
    @skill2 = FactoryGirl.create(:skill, name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
    @skill3 = FactoryGirl.create(:skill, name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
    @skill4 = FactoryGirl.create(:skill, name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)

    @skills = [@skill1.id, @skill2.id]

    @recommendation1 = FactoryGirl.create(:recommendation, product_id: @product1.id, skill_id: @skill1.id)
    @recommendation2 = FactoryGirl.create(:recommendation, product_id: @product2.id, skill_id: @skill1.id)
    @recommendation3 = FactoryGirl.create(:recommendation, product_id: @product3.id, skill_id: @skill2.id)


    @product = Product.new
    @product.name = 'new course'
    @pl = Playlist.new
    @pl.title = 'test pl 1'
  end

  test "playlist_course_added" do

    mail = Notifications.playlist_course_added @user, @pl, @product, 'http://localhost'
    # p '*'*80
    # p mail.class
    assert_equal "New course has been added to your EdgeRocket playlist", mail.subject
  end

  test "survey completed" do
    mail = Notifications.survey_completed(@user).deliver
    assert_equal "A new survey has been completed by test@edgerocket.co!", mail.subject
  end

  test "survey completed and recommendations email automatically populated and sent" do
    @hostname = 'http://localhost'
    mail = Notifications.send_recommendations(@user, @hostname, @skills).deliver
    assert_equal "EdgeRocket Recommendations", mail.subject


  end

  test "self sign up account requested" do
    pending_user = PendingUser.new(
      first_name: 'Admin',
      last_name: 'Test',
      email: 'admin-test@edgerocket.co',
      encrypted_password: 'password',
    )
    pending_user.save
    mail = Notifications.account_requested(pending_user).deliver
    assert_equal "Account request has been received", mail.subject

    mail = Notifications.account_request_received(pending_user, 'http://localhost').deliver
    assert_equal "A new self sign-up account has been requested", mail.subject
  end

  test "owners of new accounts recieve welcome emails" do

    @user.first_name = 'Bruce'
    @user.last_name = 'Wayne'
    @user.email = 'Wayne@batman.com'

    new_account = Account.new(
      company_name: "Wayne Enterprises",
      options: '{"budget_management":true,"survey":true,"discussions":"gplus","recommendations":true,"dashboard_demo":true}',
      overview: 'EdgeRocket ecnourages employees to take as many classes as possible'
    )

    new_account.save
    @user.account_id = new_account.id

    mail = Notifications.account_confirmation_email(@user, 'http://localhost', nil).deliver
    assert_equal "Welcome to EdgeRocket!", mail.subject

  end

  test "a notification is sent when admin creates a new user" do
    mail = Notifications.admin_adds_user_email(@user, 'http://localhost').deliver
    assert_equal "Welcome to EdgeRocket!", mail.subject
  end

end
