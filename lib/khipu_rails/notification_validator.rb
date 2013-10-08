require "httpclient"
require "openssl"
require "base64"

module KhipuRails
  class NotificationValidator
    def self.is_valid? notification, mode = :local
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
      receiver = KhipuRails.config.receivers.find{|r| r.id == data["receiver_id"]}
      if receiver.present?
        to_validate = data.map{|key, val| key + "=" + val}.join("&")
        signature   = Base64.decode64(signature["notification_signature"])
        digest      = OpenSSL::Digest::SHA1.new

        receiver.pkey.verify digest, signature, to_validate
      else
        # Raise exception
        false
      end
    end

    def self.webservice data, signature
      url      = 'https://khipu.com/api/1.1/verifyPaymentNotification'
      to_send  = data.merge signature
      client   = HTTPClient.new
      response = client.post url, to_send
      response.body == "VERIFIED"
    end
  end
end
