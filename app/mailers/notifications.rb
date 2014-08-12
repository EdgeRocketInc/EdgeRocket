class Notifications < ActionMailer::Base
  default from: "support@edgerocket.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.playlist_course_added.subject
  #
  def playlist_course_added(user, product)
    #byebug
    @user = user
    @product = product
    @greeting = "New course has been added to your EdgeRocket playlist"

    mail to: @user.email, subject: @greeting
  end
end
