require "openssl"

module KhipuRails
  class Receiver < Struct.new(:id, :key, :mode)
    def pkey
      @pkey ||= load_key
    end

    private

    def load_key
      cert_path = [KhipuRails.root, 'config', mode.eql?(:dev) ? 'khipu_dev.pem.cer' : 'khipu.pem.cer'].join('/')
      cert      = OpenSSL::X509::Certificate.new File.read cert_path
      cert.public_key
    end
  end
end
