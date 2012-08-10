module DelayedKiss
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      desc "Copy Delayed Kiss files to your application."

      def create_templates
        template 'config/delayed_kiss.yml', 'config/delayed_kiss.yml'
      end

    end
  end
end
