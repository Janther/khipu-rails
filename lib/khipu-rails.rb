# encoding: utf-8
require "khipu_rails"
require "khipu_rails/version"
require "khipu_rails/receiver"
require "khipu_rails/config"
require "khipu_rails/button_helper"
require "khipu_rails/notification_validator"

ActionView::Base.send :include, KhipuRails::ButtonHelper