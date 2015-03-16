Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_record.raise_in_transactional_callbacks = true
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "siraprint.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: "steve00006@gmail.com",
    password: "guybrush"
  }
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  config.serve_static_files = false
  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  # config.after_initialize do 
  #   ActiveMerchant::Billing::Base.mode = :test

  #   ::STANDARD_GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
  #     :login => "3awhpQ56UUq",
  #     :password => "6M467m5yEkAK8atH",
  #     :test => true
  #   )
  # end

  config.after_initialize do 
    ActiveMerchant::Billing::Base.mode = :test

    # ::STANDARD_GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
    #   :login => '9tGRm4AC677',
    #   :password => '2A33A46m9ds6YNfw',
    #   :test => true
    # )
    

    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(
      :login => 'Steve00006-facilitator_api1.gmail.com',
      :password => 'J5XM9SECLJQUQ9L4',
      :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AtyS01HpkH8lotQ-jwoMdrqVlah7'
    )
  end
end
