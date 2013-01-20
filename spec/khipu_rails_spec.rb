# encoding: utf-8
require 'spec_helper'

describe KhipuRails do
  it "adds the khipu_button helper to the view" do
    ActionView::Base.method_defined? :khipu_button
  end
end
