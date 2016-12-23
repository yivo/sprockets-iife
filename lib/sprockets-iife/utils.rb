# encoding: utf-8
# frozen_string_literal: true

module SprocketsIIFE
  module Utils
    class << self
      def bundle?(script_name_or_path)
        script_name = "#{File.basename(script_name_or_path, '.*')}.js"
        Rails.application.config.assets.precompile.any? do |x|
          case x
            when String then x == script_name
            when Regexp then x =~ script_name
            else false
          end
        end
      end

      def build_iife_path(script_path)
        File.join(File.dirname(script_path), "#{File.basename(script_path, '.*')}-iife.js.erb")
      end
    end
  end
end
