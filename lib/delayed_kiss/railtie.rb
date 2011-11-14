module DelayedKiss
  class Railtie < Rails::Railtie
    initializer "delayed_kiss.load_configuration" do
        env_config = YAML::load(ERB.new(IO.read(File.join(Rails.root, "config/delayed_kiss.yml"))).result)[Rails.env]
        if !config.blank?
          DelayedKiss.configure do |config|
            config.key = env_config['key']
          end
        end
     end
  end
end