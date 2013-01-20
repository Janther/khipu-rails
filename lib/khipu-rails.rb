# encoding: utf-8
require "khipu_rails/version"
require "khipu_rails/config"
require "khipu_rails/button_helper"

ActionView::Base.send :include, KhipuRails::ButtonHelper

module KhipuRails
end