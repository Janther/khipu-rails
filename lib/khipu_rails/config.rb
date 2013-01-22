module KhipuRails
  class Config
    def self.khipu_images
      {
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
    end

    def self.user_id= value
      @@user_id = value
    end

    def self.api_key= value
      @@api_key = value
    end

    def self.user_id
      @@user_id
    end

    def self.api_key
      @@api_key
    end
  end
end