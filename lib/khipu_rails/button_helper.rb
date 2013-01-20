# encoding: utf-8
module KhipuRails
  module ButtonHelper
    def khipu_button subject, amount, button_image = "50x25", options = {}
      form_tag 'https://khipu.com/payment/api/createPaymentPage', authenticity_token: false
    end
  end
end
