# encoding: utf-8
require 'spec_helper'

describe KhipuRails::Receiver do
  before :all do
    @receiver = KhipuRails::Receiver.new "1", "12345678", :dev
  end

  it "has basic attributes" do
    @receiver.respond_to?(:id).should   == true
    @receiver.respond_to?(:key).should  == true
    @receiver.respond_to?(:mode).should == true
  end
end
