# encoding: utf-8
# frozen_string_literal: true

require 'tilt'

module SprocketsIIFE
  class Processor < Tilt::Template
    def prepare
    end

    # Call processor block with `context` and `data`.
    def evaluate(context, locals, &block)
      source_file = file
      iife_file   = File.join(File.dirname(source_file), "#{File.basename(source_file, '.*')}-iife.js.erb")
      File.readable?(iife_file) ? ERB.new(File.read(iife_file)).result(binding) : data
    end

    alias source data
  end
end
