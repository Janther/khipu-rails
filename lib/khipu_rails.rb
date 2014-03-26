# encoding: utf-8
module KhipuRails
  extend self

  def configure
    yield config
  end

  def config
    @config ||= Config.default
  end

  attr_writer :config

  def khipu_hash options = {}
    OpenSSL::HMAC.digest('sha256', raw_hash(options), signature)
    Digest::SHA256.hexdigest raw_hash(options)
  end

  def raw_hash options = {}
    options.reverse_merge! KhipuRails.config.button_defaults

    if options[:receiver_id].present? and options[:secret].present?
      receiver = KhipuRails::Receiver.new options[:receiver_id], options[:secret]
    elsif options[:receiver_id].present?
      receiver = KhipuRails.config.receivers.find{|r| r.id == options[:receiver_id]}
    else
      receiver = KhipuRails.config.receivers.first
    end

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
      "picture_url=#{options[:picture_url]}",
      "secret=#{receiver.key}"
    ].join('&')

    raw
  end

  def root
    File.expand_path '../..', __FILE__
  end
end
