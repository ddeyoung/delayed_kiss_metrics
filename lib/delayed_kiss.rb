require "delayed_kiss/version"
require 'delayed_kiss/railtie' if defined?(Rails)

require 'httparty'
require 'delayed_job'

class DelayedKiss
  include HTTParty

  cattr_accessor :key
  @@key = nil

  cattr_accessor :whiny_config
  @@whiny_config = false

  cattr_accessor :config_file
  @@config_file = "config/delayed_kiss.yml"

  def self.configure
    yield self
  end

  def self.get_async(url, dj_options = {})
    self.delay(dj_options).get(url)
  end

  def self.record(id, event, query_params = {}, dj_options = {})
    self.verify_configuration
    raise ArgumentError.new("id can't be blank") if id.blank?
    raise ArgumentError.new("event can't be blank") if event.blank?

    query_params.merge!({
      '_n' => event,
      '_p' => id,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    })
    self.get_async('https://trk.kissmetrics.com/e?' + query_params.to_param, dj_options) unless @@key.blank?
  end

  def self.alias(alias_from, alias_to, dj_options = {})
    self.verify_configuration
    raise ArgumentError.new("you must specify both a from a to value") if alias_from.blank? || alias_to.blank?

    query_params = {
      '_n' => alias_to,
      '_p' => alias_from,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    }
    self.get_async('https://trk.kissmetrics.com/a?' + query_params.to_param, dj_options) unless @@key.blank?
  end

  def self.set(id, query_params, dj_options = {})
    self.verify_configuration
    raise ArgumentError.new("id can't be blank") if !id || id.blank?
    return if query_params.blank? # don't do anything if we're not setting any values on the identity

    query_params.merge!({
      '_p' => id,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    })
    self.get_async('https://trk.kissmetrics.com/s?' + query_params.to_param, dj_options) unless @@key.blank?
  end


  def self.verify_configuration
    raise DelayedKiss::ConfigurationError if @@whiny_config && @@key.blank?
  end

  class ConfigurationError < StandardError; end
end
