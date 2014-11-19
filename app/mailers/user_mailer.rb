class UserMailer < ActionMailer::Base
  default from: "siraprint.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.quote_mailer.email_quote_id.subject
  #
  def notify_new_user(user)
    @user = user

    mail to: "info@siraprint.ca", subject: "New User Waiting for Approvel"
  end
end
