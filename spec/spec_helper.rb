require 'rubygems'
require 'bundler/setup'


require 'active_support'
require 'httparty'
require 'delayed_job'
require 'delayed_kiss'

RSpec.configure do |config|
  config.mock_with :mocha
end