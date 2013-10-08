# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'khipu_rails/version'

Gem::Specification.new do |gem|
  gem.name          = "khipu-rails"
  gem.version       = KhipuRails::VERSION
  gem.authors       = ["Klaus Hott Vidal"]
  gem.email         = ["klahott@gmail.com"]
  gem.description   = %q{This gem provides an ActionView helper that creates a form following Khipu's documentation.}
  gem.summary       = %q{Wrapper for the Khipu api.}
  gem.homepage      = %q{https://github.com/janther/khipu-rails}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", ">= 3.1"
  gem.add_dependency "jquery-rails"
  gem.add_dependency "nokogiri"
  gem.add_dependency "httpclient"

  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "capybara", "~> 1.1.2"
end
