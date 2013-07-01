class DelayedKiss
  class Railtie < Rails::Railtie
    initializer "delayed_kiss.load_configuration" do
      env_config = nil
      config_file = File.join(Rails.root, DelayedKiss.config_file)
      if File.exists?(config_file)
        config_from_yaml = YAML::load(ERB.new(IO.read(config_file)).result)
        if !config_from_yaml.blank?
          env_config = config_from_yaml[Rails.env]
        end
      else
        Rails.logger.warn("DelayedKiss: Configuration file not found.")
      end
      if !env_config.blank?
        DelayedKiss.configure do |config|
          config.key = env_config['key']
          config.whiny_config = env_config['key'] || false
        end
      end
    end
  end
end
