require 'fileutils'

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

    def compile(ast, externals=[], options = {})
      options = { dump_code: false }.merge(options)
      @errors.clear

      externals = externals.map(&:to_sym)
      context = Liquor::Context.new(self, externals)
      source  = context.emitter.compile_toplevel(ast)

      if success?
        @source = source
        trace_error_message = options[:template_name].nil? ? "liquor" : "liquor #{options[:template_name]}"
        @code = eval(source, nil, trace_error_message)

        dump(options[:template_name], @source) if options[:dump_code]
      else
        @source = nil
        @code = nil
      end

      success?
    end

    def compile!(ast, externals=[], options = {})
      compile ast, externals, options

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

    protected
      def dump(name, code)
        path = defined?(Rails) ? Rails.root : File.dirname(__FILE__)
        FileUtils.mkdir_p("#{path}/compiled_templates")
        File.open("#{path}/compiled_templates/#{name}.rb", "w+") do |file|
          file.write(code)
        end
      end
  end
end
