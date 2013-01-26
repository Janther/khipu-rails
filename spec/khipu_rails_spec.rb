# encoding: utf-8
require 'spec_helper'

describe KhipuRails do
  it "adds the khipu_button helper to the view" do
    ActionView::Base.method_defined?(:khipu_button).should == true
  end

  it "Returns a Hash with the default values" do
    KhipuRails.configure do |config|
      config.receivers.merge! "123" => '1234567890asdfghjkl'
    end

    receiver = KhipuRails.config.receivers.first
    values = KhipuRails.config.button_defaults

    raw = "receiver_id=#{receiver.first}&"
    raw += "subject=#{values[:subject]}&"
    raw += "body=#{values[:body]}&"
    raw += "amount=#{values[:amount]}&"
    raw += "return_url=#{values[:return_url]}&"
    raw += "cancel_url=#{values[:cancel_url]}&"
    raw += "custom=#{values[:custom]}&"
    raw += "transaction_id=#{values[:transaction_id]}&"
    raw += "picture_url=#{values[:picture_url]}&"
    raw += "payer_email=#{values[:payer_email]}&"
    raw += "secret=#{receiver.last}"

    KhipuRails.khipu_hash.should == Digest::SHA1.hexdigest(raw)
  end
end
