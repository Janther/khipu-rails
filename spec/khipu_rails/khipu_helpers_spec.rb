# encoding: utf-8
require 'spec_helper'

describe KhipuRails::ButtonHelper do
  before do
    @view = ActionView::Base.new
  end

  it "helper generates a form with correct action" do
    button = Nokogiri::HTML.parse(@view.khipu_button "minimal", 2000)
    form = button.css('form')
    form.attribute('action').value.should eq('https://khipu.com/payment/api/createPaymentPage')
  end
end
