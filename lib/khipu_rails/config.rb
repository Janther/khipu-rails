module KhipuRails
  class Config < Struct.new(:receivers, :button_images, :button_defaults)

    def self.default
      config = new

      config.receivers = {}

      config.button_images = {
        "50x25"    => "https://s3.amazonaws.com/static.khipu.com/buttons/50x25.png",
        "100x25"   => "https://s3.amazonaws.com/static.khipu.com/buttons/100x25.png",
        "100x50"   => "https://s3.amazonaws.com/static.khipu.com/buttons/100x50.png",
        "150x25"   => "https://s3.amazonaws.com/static.khipu.com/buttons/150x25.png",
        "150x50"   => "https://s3.amazonaws.com/static.khipu.com/buttons/150x50.png",
        "150x75"   => "https://s3.amazonaws.com/static.khipu.com/buttons/150x75.png",
        "150x75-B" => "https://s3.amazonaws.com/static.khipu.com/buttons/150x75-B.png",
        "200x50"   => "https://s3.amazonaws.com/static.khipu.com/buttons/200x50.png",
        "200x75"   => "https://s3.amazonaws.com/static.khipu.com/buttons/200x75.png"
      }

      config.button_defaults = {
        subject:        '',
        amount:          1,
        body:           '',
        return_url:     '',
        cancel_url:     '',
        transaction_id: '',
        payer_email:    '',
        picture_url:    '',
        custom:         '',
        button_image:   '50x25'
      }

      config
    end

  end
end