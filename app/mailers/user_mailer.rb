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

  def signup_welcome(user)
    @user = user

    mail to: user.email, subject: "Thank You and Welcome"
  end

  def user_approved(user)
    @user = user
    mail to: user.email, subject: "Your account has been approved!"
  end

  def contact(info)
    @info = info
    mail to: "info@siraprint.ca", subject: "New Contact Submittion"
  end
end
