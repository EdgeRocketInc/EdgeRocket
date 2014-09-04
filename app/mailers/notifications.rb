class Notifications < ActionMailer::Base
  default from: "support@edgerocket.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.playlist_course_added.subject
  #
  def playlist_course_added(user, playlist, product, hostname)
    #byebug
    @user = user
    @playlist = playlist
    @product = product
    @hostname = hostname
    @greeting = "New course has been added to your EdgeRocket playlist"

    mail to: @user.email, subject: @greeting
  end

  def survey_completed(user)
    @email = user.email
    @survey_json = user.survey.preferences
    @greeting = "A new survey has been completed by #{@email}!"

    mail to: 'support@edgerocket.co', subject: @greeting
  end

  def account_requested(pending_user)
    @email = pending_user.email
    @first_name = pending_user.first_name
    @subject = "Account request has been received"

    mail to: @email, subject: @subject
  end

  def account_request_received

  end

end
