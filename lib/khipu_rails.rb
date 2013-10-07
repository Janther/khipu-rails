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
    Digest::SHA1.hexdigest raw_hash(options)
  end

  def raw_hash options = {}
    options.reverse_merge! KhipuRails.config.button_defaults

    if options[:receiver_id]
      receiver = [options[:receiver_id], (options[:secret] || KhipuRails.config.receivers[options[:receiver_id]])]
    else
      receiver = KhipuRails.config.receivers.first
    end

    raw = [
      "receiver_id=#{receiver.first}",
      "subject=#{options[:subject]}",
      "body=#{options[:body]}",
      "amount=#{options[:amount]}",
      "return_url=#{options[:return_url]}",
      "cancel_url=#{options[:cancel_url]}",
      "custom=#{options[:custom]}",
      "transaction_id=#{options[:transaction_id]}",
      "picture_url=#{options[:picture_url]}",
      "payer_email=#{options[:payer_email]}",
      "secret=#{receiver.last}"
    ].join('&')

    raw
  end

  def root
    File.expand_path '../..', __FILE__
  end
end