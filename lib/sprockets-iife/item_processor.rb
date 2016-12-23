# encoding: utf-8
# frozen_string_literal: true

module SprocketsIIFE
  class ItemProcessor
    def initialize(script_path, &block)
      @script_path   = script_path
      @script_source = block.call
    end

    def render(script_context, _)
      script_path      = @script_path
      script_source    = @script_source
      script_iife_path = SprocketsIIFE::Utils.build_iife_path(script_path)

      if File.readable?(script_iife_path) && !SprocketsIIFE::Utils.bundle?(script_path)
        script_context.depend_on(script_iife_path)

        # noinspection RubyResolve
        script_requires        = script_context._required_paths.to_a
        script_source_included = false

        script_assets = script_requires.map do |path|
          if path.include?(script_path)
            script_source_included = true
            script_source
          else
            script_context.environment.find_asset(path)
          end
        end

        script_assets << script_source unless script_source_included

        script_source = script_assets.map(&:to_s).join('')

        script_context._required_paths.clear

        SprocketsIIFE.wrap(script_path, script_source)
      else
        script_source
      end
    end

    class << self
      def call(input)
        script_path      = input[:filename]
        script_source    = input[:data]
        script_iife_path = SprocketsIIFE::Utils.build_iife_path(script_path)
        script_context   = input[:environment].context_class.new(input)

        if File.readable?(script_iife_path) && !SprocketsIIFE::Utils.bundle?(script_path)
          script_context.depend_on(script_iife_path)

          script_requires        = script_context.metadata[:required]
          script_source_included = false

          script_assets = script_requires.map do |uri|
            if uri.include?(script_path)
              script_source_included = true
              script_source
            else
              # noinspection RubyResolve
              script_context.environment.load(uri)
            end
          end

          script_assets << script_source unless script_source_included

          script_source = script_assets.map(&:to_s).join('')

          script_context.metadata.merge(required: [].to_set,
                                        data:     SprocketsIIFE.wrap(script_path, script_source))
        else
          script_context.metadata.merge(data: script_source)
        end
      end
    end
  end
end
