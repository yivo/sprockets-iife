# encoding: utf-8
# frozen_string_literal: true

require 'sprockets-iife/template'

module SprocketsIIFE
  class << self
    def wrap(script_path, script_source)
      script_iife_path = File.join(File.dirname(script_path), "#{File.basename(script_path, '.*')}-iife.js.erb")

      if File.readable?(script_iife_path)
        Template.new(script_iife_path, script_source).result
      else
        script_source
      end
    end
  end
end
