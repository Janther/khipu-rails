# encoding: utf-8
module KhipuRails
  class Engine < ::Rails::Engine
  end
  extend self

  def configure
    yield config
  end

  def config
    @config ||= Config.default
  end

  attr_writer :config

  def khipu_hash(options = {})
    options.reverse_merge! KhipuRails.config.button_defaults

    receiver = load_receiver options
    OpenSSL::HMAC.hexdigest('sha256', receiver.key, raw_hash(options, receiver))
  end

  def raw_hash(options = {}, receiver = load_receiver(options))
    options.reverse_merge! KhipuRails.config.button_defaults

    raw = [
      "receiver_id=#{receiver.id}",
      "subject=#{options[:subject]}",
      "body=#{options[:body]}",
      "amount=#{options[:amount]}",
      "payer_email=#{options[:payer_email]}",
      "bank_id=#{options[:bank_id]}",
      "expires_date=#{options[:expires_date]}",
      "transaction_id=#{options[:transaction_id]}",
      "custom=#{options[:custom]}",
      "notify_url=#{options[:notify_url]}",
      "return_url=#{options[:return_url]}",
      "cancel_url=#{options[:cancel_url]}",
      "picture_url=#{options[:picture_url]}"
    ].join('&')

    raw
  end

  def root
    File.expand_path '../..', __FILE__
  end

  private

  def load_receiver(options)
    if options[:receiver_id].present?
      if options[:secret].present?
        KhipuRails::Receiver.new options[:receiver_id], options[:secret]
      else
        KhipuRails.config.receivers.find { |r| r.id == options[:receiver_id] }
      end
    else
      KhipuRails.config.receivers.first
    end
  end
end
