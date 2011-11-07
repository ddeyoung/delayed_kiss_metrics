require "delayed_kiss/version"

module DelayedKiss
  mattr_accessor :key
  @@key = nil
  
  def self.configure
    yield self
  end

  def self.record(id, event, query_params={})
    raise DelayedKiss::ConfigurationError if @@key.blank?
    raise ArgumentError.new("id can't be blank") if id.blank?
    raise ArgumentError.new("event can't be blank") if event.blank?
    
    query_params.merge!({
      '_n' => event,
      '_p' => id,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    })
    HTTParty.delay.get('https://trk.kissmetrics.com/e?' + query_params.to_param)
  end

  def self.alias(alias_from, alias_to)
    raise DelayedKiss::ConfigurationError if @@key.blank?
    raise ArgumentError.new("you must specify both a from a to value") if alias_from.blank? || alias_to.blank?
    
    query_params = {
      '_n' => alias_to,
      '_p' => alias_from,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    }
    HTTParty.delay.get('https://trk.kissmetrics.com/a?' + query_params.to_param)
  end

  def self.set(id, query_params)
    raise DelayedKiss::ConfigurationError if @@key.blank?
    raise ArgumentError.new("id can't be blank") if !id || id.blank?
    return if query_params.blank? # don't do anything if we're not setting any values on the identity
    
    query_params.merge!({
      '_p' => id,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    })
    HTTParty.delay.get('https://trk.kissmetrics.com/s?' + query_params.to_param)
  end
  
  class ConfigurationError < StandardError; end
end
