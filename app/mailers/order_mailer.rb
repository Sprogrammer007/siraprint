class OrderMailer < ActionMailer::Base
  default from: "help@siraprint.ca"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.quote_mailer.email_quote_id.subject
  #
  def notify_order_placed(user, order)
    @user = user
    @order = order
    mail to: "info@siraprint.ca", subject: "New Order"
  end

  def thank_you_for_order(user, order)
    @user = user
    @order = order
    mail to: user.email, subject: "Thank You For Purchasing"
  end


end
