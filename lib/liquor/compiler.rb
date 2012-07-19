module Liquor
  class Compiler
    attr_reader :errors, :code

    def initialize
      @tags      = {}
      @functions = {}

      @parser = Parser.new
      @errors = []
      @code   = nil
    end

    def register_tag(tag)
      if @tags.include? tag.name
        raise Exception, "attempt to register tag #{tag.name} twict"
      end

      @tags[tag.name] = tag

      self
    end

    def has_tag?(name)
      @tags.include? name
    end

    def tag(name)
      @tags[name]
    end

    def register_function(function)
      if @functions.include? function.name
        raise Exception, "attempt to register function #{function.name} twice"
      end

      @functions[function.name] = function

      self
    end

    def has_function?(name)
      @functions.include? name
    end

    def function(name)
      @functions[name]
    end

    def compile(source, externals=[])
      @errors.clear

      externals = externals.map(&:to_sym)

      @parser.parse source
      if @parser.ast
        context = Liquor::Context.new(self, externals)
        code = context.emitter.compile_toplevel(@parser.ast)

        if success?
          @code = eval(code, nil, '(liquor)')
        else
          @code = nil
        end
      end

      success?
    end

    def compile!(source)
      compile source
      if success?
        @code
      else
        raise errors.first
      end
    end

    def errors
      @parser.errors + @errors
    end

    def add_error(error)
      @errors << error
    end

    def success?
      errors.empty?
    end

    def parse_tree
      @parser.ast
    end
  end
end