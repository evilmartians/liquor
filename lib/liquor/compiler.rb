module Liquor
  class Compiler
    attr_reader :manager
    attr_reader :errors, :source, :code
    attr_reader :tags, :functions

    def initialize(options={})
      @tags      = {}
      @functions = {}

      @errors = []
      @code   = nil

      options = options.dup
      import_builtins = options.delete(:import_builtins)
      @manager        = options.delete(:manager)

      if options.any?
        raise "Unknown compiler options #{options.keys.join ", "}"
      end

      if import_builtins || import_builtins.nil?
        Builtins.export self
        Partials.export self
      end
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

    def compile(ast, externals=[])
      @errors.clear

      externals = externals.map(&:to_sym)

      context = Liquor::Context.new(self, externals)
      source  = context.emitter.compile_toplevel(ast)

      if success?
        @source = source
        @code = eval(source, nil, '(liquor)')
      else
        @source = nil
        @code = nil
      end

      success?
    end

    def compile!(ast, externals=[])
      compile ast, externals

      if success?
        @code
      else
        raise errors.first
      end
    end

    def add_error(error)
      @errors << error
    end

    def success?
      errors.empty?
    end
  end
end