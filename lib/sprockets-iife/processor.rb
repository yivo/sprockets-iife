# encoding: utf-8
# frozen_string_literal: true

module SprocketsIIFE
  class Processor
    include Singleton

    class << self
      def call(input)
        instance.call(input)
      end
    end

    def call(input)
      @input      = input
      source_path = @input[:filename]
      iife_path   = File.join(File.dirname(source_path), "#{File.basename(source_path, '.*')}-iife.js.erb")
      File.readable?(iife_path) ? ERB.new(File.read(iife_path)).result(binding) : input[:data]
    end

    def source
      @input[:data]
    end
  end
end
