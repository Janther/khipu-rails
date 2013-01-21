# encoding: utf-8
require 'spec_helper'

describe KhipuRails::ButtonHelper do
  before :all do
    @view = ActionView::Base.new
  end

  it "generates a form with the action provided by khipu" do
    button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    form = button.css('form')
    form.attribute('action').value.should == 'https://khipu.com/payment/api/createPaymentPage'
  end

  it "generates a form with the method post" do
    button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    form = button.css('form')
    form.attribute('method').value.should == 'post'
  end

  context "given a form with minimal data was correctly generated, it" do
    before :all do
      @button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    end

    it "has an input called reciever_id" do
      input = @button.css('form input[name=receiver_id]')
      input.attribute('value').value.to_i.should == KhipuRails::Config.user_id
    end

    it "has an input called subject" do
      input = @button.css('form input[name=subject]')
      input.attribute('value').value.should == 'minimal'
    end

    it "has an input called body" do
      input = @button.css('form input[name=body]')
      input.attribute('value').value.should == ''
    end

    it "has an input called amount" do
      input = @button.css('form input[name=amount]')
      input.attribute('value').value.should == '2000'
    end

    it "has an input called return_url" do
      input = @button.css('form input[name=return_url]')
      input.attribute('value').value.should == ''
    end

    it "has an input called cancel_url" do
      input = @button.css('form input[name=cancel_url]')
      input.attribute('value').value.should == ''
    end

    it "has an input called transaction_id" do
      input = @button.css('form input[name=transaction_id]')
      input.attribute('value').value.should == ''
    end

    it "has an input called custom" do
      input = @button.css('form input[name=custom]')
      input.attribute('value').value.should == ''
    end

    it "has an input called payer_email" do
      input = @button.css('form input[name=payer_email]')
      input.attribute('value').value.should == ''
    end

    it "has an input called picture_url" do
      input = @button.css('form input[name=picture_url]')
      input.attribute('value').value.should == ''
    end

    it "has an input called hash" do
      input = @button.css('form input[name=hash]')
      input.attribute('type').value.should == 'hidden'
      input.attribute('value').value.should == '282fa35378586a753004c27002f66deeff6c8988' #Hash calculated at http://www.sha1-online.com
    end

    it "has an image submit" do
      input = @button.css('form input[name=submit]')
      input.attribute('type').value.should == 'image'
      input.attribute('src').value.should == 'https://s3.amazonaws.com/static.khipu.com/buttons/50x25.png'
    end
  end
end
