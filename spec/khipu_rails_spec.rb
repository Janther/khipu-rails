# encoding: utf-8
require 'spec_helper'

describe KhipuRails do
  it "adds the khipu_button helper to the view" do
    ActionView::Base.method_defined?(:khipu_button).should == true
  end

  it "Returns a uses the correct parameters for the Hash with the default values" do
    KhipuRails.config = nil
    KhipuRails.configure do |config|
      config.add_receiver "1392", 'b174c94de0ec3ce4f1c3156e309de45e8ce0f9ef', :dev
    end

    receiver = KhipuRails.config.receivers.first
    values = KhipuRails.config.button_defaults

    raw  = "receiver_id=#{receiver.id}&"
    raw += "subject=#{values[:subject]}&"
    raw += "body=#{values[:body]}&"
    raw += "amount=#{values[:amount]}&"
    raw += "payer_email=#{values[:payer_email]}&"
    raw += "bank_id=#{values[:bank_id]}&"
    raw += "expires_date=#{values[:expires_date]}&"
    raw += "transaction_id=#{values[:transaction_id]}&"
    raw += "custom=#{values[:custom]}&"
    raw += "notify_url=#{values[:notify_url]}&"
    raw += "return_url=#{values[:return_url]}&"
    raw += "cancel_url=#{values[:cancel_url]}&"
    raw += "picture_url=#{values[:picture_url]}"

    KhipuRails.raw_hash.should == raw
  end

  it "Returns a Hash with the default values" do
    KhipuRails.config = nil
    KhipuRails.configure do |config|
      config.add_receiver "1392", 'b174c94de0ec3ce4f1c3156e309de45e8ce0f9ef', :dev
    end

    receiver = KhipuRails.config.receivers.first
    values = KhipuRails.config.button_defaults

    raw  = "receiver_id=#{receiver.id}&"
    raw += "subject=#{values[:subject]}&"
    raw += "body=#{values[:body]}&"
    raw += "amount=#{values[:amount]}&"
    raw += "payer_email=#{values[:payer_email]}&"
    raw += "bank_id=#{values[:bank_id]}&"
    raw += "expires_date=#{values[:expires_date]}&"
    raw += "transaction_id=#{values[:transaction_id]}&"
    raw += "custom=#{values[:custom]}&"
    raw += "notify_url=#{values[:notify_url]}&"
    raw += "return_url=#{values[:return_url]}&"
    raw += "cancel_url=#{values[:cancel_url]}&"
    raw += "picture_url=#{values[:picture_url]}"

    KhipuRails.khipu_hash.should == OpenSSL::HMAC.hexdigest('sha256', receiver.key, raw)
  end
end
