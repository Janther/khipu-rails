require "uri"
require "net/http"

module KhipuRails
  class NotificationValidator
    def self.validate notification, mode = :webservice
      data = {
        api_version:     notification[:api_version],
        receiver_id:     notification[:receiver_id],
        notification_id: notification[:notification_id],
        subject:         notification[:subject],
        amount:          notification[:amount],
        currency:        notification[:currency],
        transaction_id:  notification[:transaction_id],
        payer_email:     notification[:payer_email],
        custom:          notification[:custom]
      }

      signature = { notification_signature: notification[:notification_signature] }

      self.send mode, data, signature
    end

    def self.local data, signature
    end

    def self.webservice data, signature
      url      = URI.parse 'https://khipu.com/api/1.1/verifyPaymentNotification'
      params   = data.merge signature
      binding.pry
      response = Net::HTTP.post_form(url, params)
      response
    end
  end
end
