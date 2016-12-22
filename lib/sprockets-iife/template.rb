# encoding: utf-8
# frozen_string_literal: true

require 'erb'

module SprocketsIIFE
  class Template < ERB
    def initialize(script_iife_path, script_source)
      @script_source = script_source
      super(File.read(script_iife_path))
    end

    def source
      @script_source
    end

    def result
      super(binding)
    end
  end
end
