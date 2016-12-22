# encoding: utf-8
# frozen_string_literal: true

require 'rails/railtie'

module SprocketsIIFE
  class Railtie < Rails::Railtie
    def configure_assets(app)
      if config.respond_to?(:assets) && config.assets.respond_to?(:configure)
        # Rails 4.x 5.x
        config.assets.configure { |env| yield(env) }
      else
        # Rails 3.2
        yield(app.assets)
      end
    end

    initializer 'sprockets.iife', after: 'sprockets.environment' do |app|
      configure_assets(app) do |env|
        # Sprockets 2, 3, and 4
        env.register_bundle_processor 'application/javascript', SprocketsIIFE::BundleProcessor
        env.register_postprocessor 'application/javascript', SprocketsIIFE::ItemProcessor
      end
    end
  end
end
