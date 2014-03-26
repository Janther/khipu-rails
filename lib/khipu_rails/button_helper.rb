# encoding: utf-8
module KhipuRails
  module ButtonHelper
    def khipu_button subject, amount, options = {}
      options.reverse_merge! body:           '',
                             payer_email:    '',
                             bank_id:        '',
                             expires_date:   '',
                             notify_url:     '',
                             return_url:     '',
                             cancel_url:     '',
                             transaction_id: '',
                             picture_url:    '',
                             custom:         '',
                             button_image:   '50x25',                             #Default Button Image
                             receiver_id:    KhipuRails.config.receivers.first.id #Loads first receiver from configuration by default

      button_image = KhipuRails.config.button_images()[options[:button_image]] || options[:button_image]

      form_tag 'https://khipu.com/api/1.3/createPaymentPage', authenticity_token: false do
        fields = [].tap do |i|
          i << hidden_field_tag(:receiver_id,    options[:receiver_id])
          i << hidden_field_tag(:subject, subject)
          i << hidden_field_tag(:body,           options[:body])
          i << hidden_field_tag(:amount,  amount)
          i << hidden_field_tag(:payer_email,    options[:payer_email])
          i << hidden_field_tag(:bank_id,        options[:bank_id])
          i << hidden_field_tag(:expires_date,   options[:expires_date])
          i << hidden_field_tag(:transaction_id, options[:transaction_id])
          i << hidden_field_tag(:custom,         options[:custom])
          i << hidden_field_tag(:notify_url,     options[:notify_url])
          i << hidden_field_tag(:return_url,     options[:return_url])
          i << hidden_field_tag(:cancel_url,     options[:cancel_url])
          i << hidden_field_tag(:picture_url,    options[:picture_url])
        end.join.html_safe

        ng = Nokogiri::HTML.parse fields

        hash_fields = {
          receiver_id:    get_value(ng, :receiver_id),
          subject:        get_value(ng, :subject),
          body:           get_value(ng, :body),
          amount:         get_value(ng, :amount),
          payer_email:    get_value(ng, :payer_email),
          bank_id:        get_value(ng, :bank_id),
          expires_date:   get_value(ng, :expires_date),
          transaction_id: get_value(ng, :transaction_id),
          custom:         get_value(ng, :custom),
          notify_url:     get_value(ng, :notify_url),
          return_url:     get_value(ng, :return_url),
          cancel_url:     get_value(ng, :cancel_url),
          picture_url:    get_value(ng, :picture_url),
          secret:         options[:secret]
        }

        [fields].tap do |i|
          i << hidden_field_tag(:hash, KhipuRails.khipu_hash(hash_fields))
          i << image_submit_tag(button_image, name: :submit)
        end.join.html_safe
      end
    end

    private
    def get_value inputs, attribute
      inputs.css("input[name=#{attribute}]").attribute('value').value
    end
  end
end
