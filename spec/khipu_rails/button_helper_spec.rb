# encoding: utf-8
require 'spec_helper'

describe KhipuRails::ButtonHelper do
  before :all do
    KhipuRails.configure do |config|
      config.receivers.merge! "123" => '1234567890asdfghjkl'
    end
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

  context "given a form with minimal data was generated, it" do
    before :all do
      @receiver_id = KhipuRails.config.receivers.keys.first
      @secret = KhipuRails.config.receivers[@receiver_id]
      @button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    end

    it "has an input called reciever_id" do
      input = @button.css('form input[name=receiver_id]')
      input.attribute('value').value.should == @receiver_id
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
      def get_value attribute
        @button.css("form input[name=#{attribute}]").attribute('value').value
      end
      raw = "receiver_id=#{get_value :receiver_id}&"
      raw += "subject=#{get_value :subject}&"
      raw += "body=#{get_value :body}&"
      raw += "amount=#{get_value :amount}&"
      raw += "return_url=#{get_value :return_url}&"
      raw += "cancel_url=#{get_value :cancel_url}&"
      raw += "custom=#{get_value :custom}&"
      raw += "transaction_id=#{get_value :transaction_id}&"
      raw += "picture_url=#{get_value :picture_url}&"
      raw += "payer_email=#{get_value :payer_email}&"
      raw += "secret=#{@secret}"
      input.attribute('value').value.should == Digest::SHA1.hexdigest(raw)
    end

    it "has an image submit" do
      input = @button.css('form input[name=submit]')
      input.attribute('type').value.should == 'image'
      input.attribute('src').value.should == 'https://s3.amazonaws.com/static.khipu.com/buttons/50x25.png'
    end
  end

  context "given a form with full optional data was generated, it" do
    before :all do
      @receiver_id = 4321
      @secret = 'lkjhgfdsa0987654321'
      @button = Nokogiri::HTML.parse(@view.khipu_button "full", 1_000_000,
        body:           'This is a full body',
        return_url:     'http://foo.bar',
        cancel_url:     'http://bar.foo',
        transaction_id: 'asdf1234',
        payer_email:    'testing@khipu.com',
        picture_url:    'http://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg',
        custom:         "Just testing\nwhat this api\tsupports.",
        button_image:   '150x75-B',
        receiver_id:    @receiver_id,
        secret:         @secret
      )
    end

    it "has an input called reciever_id" do
      input = @button.css('form input[name=receiver_id]')
      input.attribute('value').value.should == @receiver_id.to_s
    end

    it "has an input called subject" do
      input = @button.css('form input[name=subject]')
      input.attribute('value').value.should == 'full'
    end

    it "has an input called body" do
      input = @button.css('form input[name=body]')
      input.attribute('value').value.should == 'This is a full body'
    end

    it "has an input called amount" do
      input = @button.css('form input[name=amount]')
      input.attribute('value').value.should == '1000000'
    end

    it "has an input called return_url" do
      input = @button.css('form input[name=return_url]')
      input.attribute('value').value.should == 'http://foo.bar'
    end

    it "has an input called cancel_url" do
      input = @button.css('form input[name=cancel_url]')
      input.attribute('value').value.should == 'http://bar.foo'
    end

    it "has an input called transaction_id" do
      input = @button.css('form input[name=transaction_id]')
      input.attribute('value').value.should == 'asdf1234'
    end

    it "has an input called custom" do
      input = @button.css('form input[name=custom]')
      input.attribute('value').value.should == "Just testing\nwhat this api\tsupports."
    end

    it "has an input called payer_email" do
      input = @button.css('form input[name=payer_email]')
      input.attribute('value').value.should == 'testing@khipu.com'
    end

    it "has an input called picture_url" do
      input = @button.css('form input[name=picture_url]')
      input.attribute('value').value.should == 'http://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg'
    end

    it "has an input called hash" do
      input = @button.css('form input[name=hash]')
      input.attribute('type').value.should == 'hidden'
      def get_value attribute
        @button.css("form input[name=#{attribute}]").attribute('value').value
      end
      raw = "receiver_id=#{get_value :receiver_id}&"
      raw += "subject=#{get_value :subject}&"
      raw += "body=#{get_value :body}&"
      raw += "amount=#{get_value :amount}&"
      raw += "return_url=#{get_value :return_url}&"
      raw += "cancel_url=#{get_value :cancel_url}&"
      raw += "custom=#{get_value :custom}&"
      raw += "transaction_id=#{get_value :transaction_id}&"
      raw += "picture_url=#{get_value :picture_url}&"
      raw += "payer_email=#{get_value :payer_email}&"
      raw += "secret=#{@secret}"
      input.attribute('value').value.should == Digest::SHA1.hexdigest(raw)
    end

    it "has an image submit" do
      input = @button.css('form input[name=submit]')
      input.attribute('type').value.should == 'image'
      input.attribute('src').value.should == 'https://s3.amazonaws.com/static.khipu.com/buttons/150x75-B.png'
    end
  end
end
