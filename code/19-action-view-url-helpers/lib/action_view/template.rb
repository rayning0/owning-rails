require 'erb'

module ActionView
  class Template
    CACHE = Hash.new do |cache, file|
      cache[file] = Template.new(File.read(file), file)
    end

    def self.find(file)
      CACHE[file]
    end

    def initialize(source, name)
      @source = source
      @name = name
      @compiled = false
    end

    def render(context, &block)
      compile
      context.send(method_name, &block)
    end

    def method_name
      @name.gsub(/[^\w]/, '_')
    end

    def compile
      return if @compiled
      code = ERB.new(@source).src

      CompiledTemplates.module_eval <<-CODE
        def #{method_name}
          #{code}
        end
      CODE
      
      @compiled = true
    end
  end
end