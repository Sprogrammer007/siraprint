module UploadHelper
  def s3_uploader_form(options = {}, &block)
    uploader = S3Uploader.new(options)
    form_tag(uploader.url, uploader.form_options) do
      uploader.fields.map do |name, value|
        hidden_field_tag(name, value)
      end.join.html_safe + capture(&block)
    end
  end

  class S3Uploader
    def initialize(options)
      @options = options.reverse_merge(
        id: "fileupload",
        aws_access_key_id:  ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket: ENV['AWS_BUCKET_EAST'],        
        acl: "public-read",
        expiration: 2.hours.from_now,
        max_file_size: 200.megabytes,
        as: "file"
      )
    end

    def form_options
      {
        id: @options[:id],
        method: "post",
        authenticity_token: false,
        multipart: true,
        data: {
          patch: @options[:patch],
          side: @options[:side],
          oid: @options[:oid],
          as: @options[:as],
          destroy: @options[:destroy],
          success: @options[:success]
        }
      }
    end

    def fields
      {
        :key => key,
        :acl => @options[:acl],
        :policy => policy,
        :signature => signature,
        "AWSAccessKeyId" => @options[:aws_access_key_id]
      }
    end

    def key
      @key ||= "uploads/#{Date.today}/#{@options[:oid]}/${filename}"
    end

    def url
      # "https://#{@options[:bucket]}.s3.amazonaws.com/"
      "https://dj6kqp5fwtqnd.cloudfront.net/"
    end

    def policy
      Base64.encode64(policy_data.to_json).gsub("\n", "")
    end

    def policy_data
      {
        expiration: @options[:expiration],
        conditions: [
          ["starts-with", "$utf8", ""],
          ["starts-with", "$key", ""],
          ["content-length-range", 0, @options[:max_file_size]],
          {bucket: @options[:bucket]},
          {acl: @options[:acl]}
        ]
      }
    end

    def signature
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha1'),
          @options[:aws_secret_access_key], policy
        )
      ).gsub("\n", "")
    end
  end
end