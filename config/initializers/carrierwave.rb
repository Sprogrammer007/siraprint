CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = 'stevetest2'
  config.aws_acl    = :public_read
  # config.asset_host = 'http://example.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     'AKIAJQFWQPZ6HD6JFLUA',  
    secret_access_key: 'K7WCDVUnNnmcQ4b2HMpt64J8WmZoAABYzDAusA7F'
  }
end