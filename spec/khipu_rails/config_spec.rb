# encoding: utf-8
require 'spec_helper'

describe KhipuRails::Config do
  context "Empty Configuration" do
    before :all do
      KhipuRails.configure do |config|
      end
    end

    it 'has no receiver key/value pairs' do
      KhipuRails.config.receivers.count.should == 0
    end

    it 'has button_image key/value pairs provided by Khipu' do
      KhipuRails.config.button_images["50x25"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/50x25.png"
      KhipuRails.config.button_images["100x25"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/100x25.png"
      KhipuRails.config.button_images["100x50"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/100x50.png"
      KhipuRails.config.button_images["150x25"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/150x25.png"
      KhipuRails.config.button_images["150x50"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/150x50.png"
      KhipuRails.config.button_images["150x75"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/150x75.png"
      KhipuRails.config.button_images["150x75-B"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/150x75-B.png"
      KhipuRails.config.button_images["200x50"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/200x50.png"
      KhipuRails.config.button_images["200x75"].should == "https://s3.amazonaws.com/static.khipu.com/buttons/200x75.png"
      KhipuRails.config.button_images.count.should == 9
    end

    it 'sets defaults' do
      KhipuRails.config.defaults[:subject].should == ''
    end
  end
  context "Full Configuration" do
    before :all do
      KhipuRails.configure do |config|
        config.receivers.merge '123' => '1234567890asdfghjkl', '321' => 'lkjhgfdsa0987654321'
        config.button_images.merge my_button: 'http://my_site.cl/my_button.png'
        config.defaults.merge subject: 'Compra de Puntos Cumplo',
      end
    end

    it 'adds receiver key/value pairs' do
      KhipuRails.config.receivers.keys.first.should == '123'
      KhipuRails.config.receivers.values.first.should == '1234567890asdfghjkl'
      KhipuRails.config.receivers.keys.last.should == '321'
      KhipuRails.config.receivers.values.last.should == 'lkjhgfdsa0987654321'
      KhipuRails.config.receivers['123'].should == '1234567890asdfghjkl'
      KhipuRails.config.receivers['321'].should == 'lkjhgfdsa0987654321'
    end

    it 'adds button_image key/value pairs' do
      KhipuRails.config.button_images.keys.last.should == :my_button
      KhipuRails.config.button_images.values.last.should == 'http://my_site.cl/my_button.png'
      KhipuRails.config.button_images[:my_button].should == 'http://my_site.cl/my_button.png'
    end

    it 'should not delete previous button_image key/value pairs' do
      KhipuRails.config.button_images.count.should_not == 1
    end

    it 'sets defaults' do
      KhipuRails.config.button_defaults[:subject].should == 'Compra de Puntos Cumplo'
    end
  end
end