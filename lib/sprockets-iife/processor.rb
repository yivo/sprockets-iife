# encoding: utf-8
# frozen_string_literal: true

module SprocketsIIFE
  class AbstractProcessor
    def initialize(script_path, &block)
      @script_path   = script_path
      @script_source = block.call
    end

    def render(_, _)
      self.class.wrap(@script_path, @script_source)
    end

    class << self
      def call(input)
        script_path   = input[:filename]
        script_source = input[:data]
        context       = input[:environment].context_class.new(input)
        context.metadata.merge(data: wrap(script_path, script_source))
      end

      def wrap(script_path, script_source)
        raise NotImplementedError
      end
    end
  end

  class ItemProcessor < AbstractProcessor
    class << self
      def wrap(script_path, script_source)
        script_name = "#{File.basename(script_path, '.*')}.js"
        seems_to_be_a_bundle = Rails.application.config.assets.precompile.any? do |x|
          case x
            when String then x == script_name
            when Regexp then x =~ script_name
            else false
          end
        end

        if seems_to_be_a_bundle
          script_source
        else
          SprocketsIIFE.wrap(script_path, script_source)
        end
      end
    end
  end

  class BundleProcessor < AbstractProcessor
    class << self
      def wrap(script_path, script_source)
        SprocketsIIFE.wrap(script_path, script_source)
      end
    end
  end
end
