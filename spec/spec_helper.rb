# Configure Rails Envinronment
ENV["RAILS_ENV"] ||= 'test'

require "action_view/railtie"
require "nokogiri"
require 'khipu-rails'

KhipuRails::Config.user_id = 1234
KhipuRails::Config.api_key = '1234567890asdfghjkl'