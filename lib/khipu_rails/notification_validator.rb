require "uri"
require "httpclient"
require "openssl"
require "base64"

module KhipuRails
  class NotificationValidator
    def self.validate notification, mode = :webservice
      data = {
        "api_version"     => notification[:api_version],
        "receiver_id"     => notification[:receiver_id],
        "notification_id" => notification[:notification_id],
        "subject"         => notification[:subject],
        "amount"          => notification[:amount],
        "currency"        => notification[:currency],
        "transaction_id"  => notification[:transaction_id],
        "payer_email"     => notification[:payer_email],
        "custom"          => notification[:custom]
      }

      signature = { "notification_signature" => notification[:notification_signature] }

      self.send mode, data, signature
    end

    def self.local data, signature
      cert_path   = [KhipuRails.root, 'config', 'khipu', Rails.env.eql?('production') ? 'khipu.pem.cer' : 'khipu_dev.pem.cer'].join('/')
      cert        = OpenSSL::X509::Certificate.new File.read cert_path
      pkey        = cert.public_key
      to_validate = data.map{|key, val| key + "=" + val}.join("&")
      signature   = Base64.decode64(signature["notification_signature"])
      digest      = OpenSSL::Digest::SHA1.new
      pkey.verify digest, signature, to_validate
    end

    def self.webservice data, signature
      url      = URI.parse 'https://khipu.com/api/1.1/verifyPaymentNotification'
      to_send  = data.merge signature
      client   = HTTPClient.new
      response = client.post url, to_send
      response.body == "VERIFIED"
    end
  end
end
