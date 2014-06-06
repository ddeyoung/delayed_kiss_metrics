require 'rubygems'
require 'bundler/setup'


require 'active_support'
require 'active_support/core_ext'
require 'httparty'
require 'delayed_job'
require 'delayed_kiss'

RSpec.configure do |config|
  config.mock_with :mocha
end

DelayedKiss.configure do |config|
  config.key = "dlf23jkd9sl32nfj99kl2s8635h3jk33f"
end

# provide methods for clearing and restoring the configurations
class DelayedKiss
  @@cached_key = nil

  def self.cache_config
    @@cached_key = @@key
  end

  def self.reset_config
    @@key = @@cached_key if @@cached_key
  end
end

# ignore delaying jobs
module Delayed::MessageSending
  def delay(options = {})
    return self
  end
end
