# CarrierWave.configure do |config|
#   config.storage    = :aws
#   config.aws_bucket = ENV['AWS_BUCKET']
#   config.aws_acl    = :public_read
#   # config.asset_host = 'http://example.com'
#   config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

#   config.aws_credentials = {
#     access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
#     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#     region: 'us-west-2'
#   }
# end

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = "stevetest2"
  config.aws_acl    = :public_read
  # config.asset_host = 'http://example.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:    "AKIAIVC2RNXGQ3UFNQCQ",
    secret_access_key: "7uqrOSzAvBUYw2pkv0BO/7eByRGdZwtjgmxXuvRV",
  }
end
