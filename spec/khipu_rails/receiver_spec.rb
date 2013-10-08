# encoding: utf-8
require 'spec_helper'
require "openssl"

describe KhipuRails::Receiver do
  before :all do
    @dev = KhipuRails::Receiver.new "1", "12345678", :dev
    @pro = KhipuRails::Receiver.new "2", "87654321", :prod
  end

  it "has basic attributes" do
    @dev.respond_to?(:id).should   == true
    @dev.respond_to?(:key).should  == true
    @dev.respond_to?(:mode).should == true
  end

  it "loads the correct public key" do
    dev_cert_path = [KhipuRails.root, 'config', 'khipu_dev.pem.cer'].join('/')
    dev_cert      = OpenSSL::X509::Certificate.new File.read dev_cert_path
    @dev.pkey.to_s.should == dev_cert.public_key.to_s

    pro_cert_path = [KhipuRails.root, 'config', 'khipu.pem.cer'].join('/')
    pro_cert      = OpenSSL::X509::Certificate.new File.read pro_cert_path
    @pro.pkey.to_s.should == pro_cert.public_key.to_s
  end
end
