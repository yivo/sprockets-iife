# encoding: utf-8
# frozen_string_literal: true

module SprocketsIIFE
  class << self
    def wrap(script_path, script_source)
      script_iife_path = SprocketsIIFE::Utils.build_iife_path(script_path)
      SprocketsIIFE::Template.new(script_iife_path, script_source).result
    end
  end
end
