module Liquor
  class Manager
    attr_reader :diagnostics

    def initialize(options={})
      import   = options.delete(:import).to_a || []
      @dump_ir = options.delete(:dump_intermediates)

      if options.any?
        raise "Unknown function options: #{options.keys.join ", "}"
      end

      @compiler  = Liquor::Compiler.new(manager: self)
      import.each do |library|
        library.export @compiler
      end

      @parser    = Liquor::Parser.new(@compiler.tags)

      @sources   = {}
      @templates = {}
      @partials  = {}
      @compiled_templates = nil

      @diagnostics = []
    end

    def partial?(name)
      name.start_with? '_'
    end

    def register_template(name, source, externals=[])
      if partial? name
        raise ::ArgumentError, "Template `#{name}' is a partial"
      end

      @sources[name] = source.dup

      if @parser.parse(source, name)
        @templates[name.to_s] = [ @parser.ast, externals ]
      else
        @diagnostics.concat @parser.errors
      end
    end

    def register_layout(name, source, externals=[])
      register_template name, source, externals + [ :_inner_template ]
    end

    def register_partial(name, source)
      unless partial? name
        raise ::ArgumentError, "Template `#{name}' is not a partial"
      end

      @sources[name] = source.dup

      if @parser.parse(source, name)
        @partials[name.to_s] = @parser.ast
      else
        @partials[name.to_s] = :syntax_error
        @diagnostics.concat @parser.errors
      end
    end

    def fetch_partial(name)
      @partials[name.to_s]
    end

    def compile
      @compiled_templates = {}

      @templates.each do |name, (template, externals)|
        @compiler.compile(template, externals, name)
        dump_intermediates(name, template)

        if @compiler.success?
          @compiled_templates[name] = @compiler.code
        else
          @diagnostics.concat @compiler.diagnostics
        end
      end

      success?
    end

    def errors
      diagnostics.select &:error?
    end

    def success?
      errors.none?
    end

    def has_template?(name)
      !@compiled_templates[name].nil?
    end

    def render(name, externals={}, storage={})
      if @compiled_templates.nil?
        raise ::RuntimeError, "Call #compile before #render"
      end

      template = @compiled_templates[name]
      if template.nil?
        raise Error.new("Template `#{name}' does not exist")
      end

      template.call(externals, storage)
    end

    def render_with_layout(layout_name, layout_externals,
                           template_name, template_externals,
                           storage={})
      template_result = render(template_name, template_externals, storage)
      layout_result   = render(layout_name, layout_externals.
                            merge(_inner_template: template_result), storage)

      layout_result
    end

    def decorate(error)
      decorated = []

      if error.is_a? Diagnostic
        if error.location
          if file = error.location[:file]
            decorated = error.decorate @sources[file]
          end
        end
      end

      decorated
    end

    protected

    def dump_intermediates(template_name, liquor_source)
      if @dump_ir
        path = File.join(@dump_ir, "#{template_name}.liquor.rb")
        if @compiler.success?
          File.write(path, @compiler.source)
        end
      end
    end
  end
end
