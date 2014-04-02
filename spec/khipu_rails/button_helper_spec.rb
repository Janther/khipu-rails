# encoding: utf-8
require 'spec_helper'

describe KhipuRails::ButtonHelper do
  before :all do
    KhipuRails.config = nil
    KhipuRails.configure do |config|
      config.add_receiver "1392", 'b174c94de0ec3ce4f1c3156e309de45e8ce0f9ef', :dev
    end
    @view = ActionView::Base.new
  end

  it "generates a form with the action provided by khipu" do
    button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    form = button.css('form')
    form.attribute('action').value.should == 'https://khipu.com/api/1.3/createPaymentPage'
  end

  it "generates a form with the method post" do
    button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    form = button.css('form')
    form.attribute('method').value.should == 'post'
  end

  context "given a form with minimal data was generated, it" do
    before :all do
      @receiver_id = KhipuRails.config.receivers.first.id
      @secret = KhipuRails.config.receivers.first.key
      @button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    end

    it "has an input called reciever_id" do
      attribute_value(:receiver_id).should == @receiver_id
    end

    it "has an input called subject" do
      attribute_value(:subject).should == 'minimal'
    end

    it "has an input called body" do
      attribute_value(:body).should == ''
    end

    it "has an input called amount" do
      attribute_value(:amount).should == '2000'
    end

    it "has an input called return_url" do
      attribute_value(:return_url).should == ''
    end

    it "has an input called cancel_url" do
      attribute_value(:cancel_url).should == ''
    end

    it "has an input called transaction_id" do
      attribute_value(:transaction_id).should == ''
    end

    it "has an input called custom" do
      attribute_value(:custom).should == ''
    end

    it "has an input called payer_email" do
      attribute_value(:payer_email).should == ''
    end

    it "has an input called picture_url" do
      attribute_value(:picture_url).should == ''
    end

    it "has an input called hash" do
      attribute_value(:hash, :type).should == 'hidden'

      raw  = "receiver_id=#{attribute_value :receiver_id}&"
      raw += "subject=#{attribute_value :subject}&"
      raw += "body=#{attribute_value :body}&"
      raw += "amount=#{attribute_value :amount}&"
      raw += "payer_email=#{attribute_value :payer_email}&"
      raw += "bank_id=#{attribute_value :bank_id}&"
      raw += "expires_date=#{attribute_value :expires_date}&"
      raw += "transaction_id=#{attribute_value :transaction_id}&"
      raw += "custom=#{attribute_value :custom}&"
      raw += "notify_url=#{attribute_value :notify_url}&"
      raw += "return_url=#{attribute_value :return_url}&"
      raw += "cancel_url=#{attribute_value :cancel_url}&"
      raw += "picture_url=#{attribute_value :picture_url}"
      attribute_value(:hash).should == OpenSSL::HMAC.hexdigest('sha256', @secret, raw)
    end

    it "has an image submit" do
      attribute_value(:submit, :type).should == 'image'
      attribute_value(:submit, :src).should == 'https://s3.amazonaws.com/static.khipu.com/buttons/50x25.png'
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
      attribute_value(:receiver_id).should == @receiver_id.to_s
    end

    it "has an input called subject" do
      attribute_value(:subject).should == 'full'
    end

    it "has an input called body" do
      attribute_value(:body).should == 'This is a full body'
    end

    it "has an input called amount" do
      attribute_value(:amount).should == '1000000'
    end

    it "has an input called return_url" do
      attribute_value(:return_url).should == 'http://foo.bar'
    end

    it "has an input called cancel_url" do
      attribute_value(:cancel_url).should == 'http://bar.foo'
    end

    it "has an input called transaction_id" do
      attribute_value(:transaction_id).should == 'asdf1234'
    end

    it "has an input called custom" do
      attribute_value(:custom).should == "Just testing\nwhat this api\tsupports."
    end

    it "has an input called payer_email" do
      attribute_value(:payer_email).should == 'testing@khipu.com'
    end

    it "has an input called picture_url" do
      attribute_value(:picture_url).should == 'http://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/402px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg'
    end

    it "has an input called hash" do
      attribute_value(:hash, :type).should == 'hidden'

      raw  = "receiver_id=#{attribute_value :receiver_id}&"
      raw += "subject=#{attribute_value :subject}&"
      raw += "body=#{attribute_value :body}&"
      raw += "amount=#{attribute_value :amount}&"
      raw += "payer_email=#{attribute_value :payer_email}&"
      raw += "bank_id=#{attribute_value :bank_id}&"
      raw += "expires_date=#{attribute_value :expires_date}&"
      raw += "transaction_id=#{attribute_value :transaction_id}&"
      raw += "custom=#{attribute_value :custom}&"
      raw += "notify_url=#{attribute_value :notify_url}&"
      raw += "return_url=#{attribute_value :return_url}&"
      raw += "cancel_url=#{attribute_value :cancel_url}&"
      raw += "picture_url=#{attribute_value :picture_url}"
      attribute_value(:hash).should == OpenSSL::HMAC.hexdigest('sha256', @secret, raw)
    end

    it "has an image submit" do
      attribute_value(:submit, :type).should == 'image'
      attribute_value(:submit, :src).should == 'https://s3.amazonaws.com/static.khipu.com/buttons/150x75-B.png'
    end
  end

  context "form with only options" do
    before :all do
      KhipuRails.config = nil
      KhipuRails.configure do |config|
        config.add_receiver "1392", 'b174c94de0ec3ce4f1c3156e309de45e8ce0f9ef', :dev
        config.add_receiver "321", 'lkjhgfdsa0987654321', :dev
        config.button_defaults.merge! subject: 'Compra de Puntos Cumplo',
                                      amount: 3000
      end
    end

    it "allows developers to provide their own button_image" do
      button = Nokogiri::HTML.parse(@view.khipu_button "image", 1)
      input = button.css('form input[name=receiver_id]')
    end
  end
end

def attribute_value input, attribute = :value, form = @button
  form.css("form input[name=#{input.to_s}]").attribute(attribute.to_s).value
end
