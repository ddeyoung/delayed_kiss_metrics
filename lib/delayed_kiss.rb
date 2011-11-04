require "delayed_kiss/version"

module DelayedKiss
  mattr_accessor :key
  @@key = nil
  
  def self.configure
    yield self
  end

  def self.record(id, event, properties={})
    params = {
      '_n' => event,
      '_p' => id,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    }
    params.merge!(properties)
    HTTParty.delay.get('https://trk.kissmetrics.com/e?' + params.to_param) unless @@key.blank?
  end

  def self.alias(name, alias_to)
    params = {
      '_n' => alias_to,
      '_p' => name,
      '_t' => Time.now.to_i.to_s,
      '_k' => @@key
    }
    HTTParty.delay.get('https://trk.kissmetrics.com/a?' + params.to_param) unless @@key.blank?
  end

  def self.set(id, params)
    params['_p'] = id
    params['_t'] = Time.now.to_i.to_s
    params['_k'] = @@key
    HTTParty.delay.get('https://trk.kissmetrics.com/s?' + params.to_param) unless @@key.blank?
  end
end
