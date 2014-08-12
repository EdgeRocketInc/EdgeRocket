require 'test_helper'

class NotificationsTest < ActionMailer::TestCase

  user = User.new 
  user.email = 'test@EdgeRocket.co'
  product = Product.new
  product.name = 'new course'
  test "playlist_course_added" do
    mail = Notifications.playlist_course_added user, product
    assert_equal "New course has been added to your EdgeRocket playlist", mail.subject
  end

end
