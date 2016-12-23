# encoding: utf-8
# frozen_string_literal: true

module SprocketsIIFE
  class BundleProcessor
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
        script_iife_path = SprocketsIIFE::Utils.build_iife_path(script_path)

        if File.readable?(script_iife_path) && SprocketsIIFE::Utils.bundle?(script_path)
          SprocketsIIFE::Template.new(script_iife_path, script_source).result
        else
          script_source
        end
      end
    end
  end
end
