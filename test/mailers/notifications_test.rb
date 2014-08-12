require 'test_helper'

class NotificationsTest < ActionMailer::TestCase

  user = User.find(101)
  product = Product.find(2001)
  test "playlist_course_added" do
    mail = Notifications.playlist_course_added user, product
    assert_equal "New course has been added to your EdgeRocket playlist", mail.subject
  end

end
