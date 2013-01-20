# encoding: utf-8
module KhipuRails
  module ButtonHelper
    def khipu_button subject, amount, options = {}
      options.reverse_merge! body:           '',
                             return_url:     '',
                             cancel_url:     '',
                             transaction_id: '',
                             payer_email:    '',
                             picture_url:    '',
                             custom:         '',
                             button_image:   '50x25',                    #Default Button Image
                             receiver_id:    KhipuRails::Config.user_id, #Loads user id from configuration
                             secret:         KhipuRails::Config.api_key  #Loads api key from configuration

      options[:subject] = subject #Adds the subject param to the options for khipu_hash
      options[:amount]  = amount  #Adds the amount param to the options for khipu_hash

      button_image = KhipuRails::Config.khipu_images()[options[:button_image]] || options[:button_image]

      form_tag 'https://khipu.com/payment/api/createPaymentPage', authenticity_token: false do
        [].tap do |i|
          i << hidden_field_tag(:receiver_id, options[:receiver_id])
          i << hidden_field_tag(:subject, subject)
          i << hidden_field_tag(:body, options[:body])
          i << hidden_field_tag(:amount, amount)
          i << hidden_field_tag(:return_url, options[:return_url])
          i << hidden_field_tag(:cancel_url, options[:cancel_url])
          i << hidden_field_tag(:transaction_id, options[:transaction_id])
          i << hidden_field_tag(:payer_email, options[:payer_email])
          i << hidden_field_tag(:picture_url, options[:picture_url])
          i << hidden_field_tag(:hash, khipu_hash(options))
          i << image_submit_tag(button_image, name: :submit)
        end.join.html_safe
      end
    end

    private
    def khipu_hash options = {}
      raw = [
        "receiver_id=#{options[:receiver_id]}",
        "subject=#{options[:subject]}",
        "body=#{options[:body]}",
        "amount=#{options[:amount]}",
        "return_url=#{options[:return_url]}",
        "cancel_url=#{options[:cancel_url]}",
        "custom=#{options[:custom]}",
        "transaction_id=#{options[:transaction_id]}",
        "picture_url=#{options[:picture_url]}",
        "payer_email=#{options[:payer_email]}",
        "secret=#{options[:secret]}"
      ].join('&')
      Digest::SHA1.hexdigest raw
    end
  end
end
