# Preview all emails at http://localhost:3000/rails/mailers/notifications
class NotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications/playlist_course_added
  def playlist_course_added
	user = User.find(101)
	product = Product.find(2001)

	Notifications.playlist_course_added user, product
  end

end
