module SprocketsIIFE
  class Processor
    VERSION = '1'
    include Singleton

    class << self
      delegate :call, :cache_key, to: :instance
    end

    attr_reader :cache_key

    def initialize(options = {})
      @cache_key = [self.class.name, VERSION, options].freeze
    end

    def call(input)
      @input   = input
      filepath = @input[:filename]
      iife     = File.join(File.dirname(filepath), "#{File.basename(filepath, '.*')}-iife.js.erb")
      File.exists?(iife) ? ERB.new(File.read(iife)).result(binding) : input[:data]
    end

    def source
      @input[:data]
    end
  end
end
