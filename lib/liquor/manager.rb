module Liquor
  class Manager
    attr_reader :compiler

    def initialize
      @compiler  = Liquor::Compiler.new
      @templates = {}
    end

    def register(name, code)
      @templates[name.to_s] = code
    end

    def compile_and_register!(name, source, externals=[])
      register name, @compiler.compile!(source, externals)
    end

    def fetch(name)
      @templates[name.to_s]
    end
  end
end