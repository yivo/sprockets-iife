module SprocketsIIFE
  class Railtie < Rails::Engine
    initializer :sprockets_iife do |app|
      proc = -> (env = nil) {
        (env || app.assets).register_bundle_processor 'application/javascript', ::SprocketsIIFE::Processor
      }
      if app.config.assets.respond_to?(:configure)
        app.config.assets.configure do |env|
          require 'sprockets-iife/processor-v3'
          proc.call(env)
        end
      else
        require 'sprockets-iife/processor-v2'
        proc.call
      end
    end
  end
end
