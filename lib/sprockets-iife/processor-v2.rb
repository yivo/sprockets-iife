module SprocketsIIFE
  class Processor < Sprockets::Processor
    def evaluate(context, locals)
      iife = File.join(File.dirname(file), "#{File.basename(file, '.*')}-iife.js.erb")
      File.exists?(iife) ? ERB.new(File.read(iife)).result(binding) : data
    end

    alias source data
  end
end
