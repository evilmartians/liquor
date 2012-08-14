module Liquor
  class Manager
    attr_reader :errors

    def initialize(options={})
      import = options.delete(:import).to_a || []
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

      @errors = []
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
        @errors.concat @parser.errors
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
        @errors.concat @parser.errors
      end
    end

    def fetch_partial(name)
      @partials[name.to_s]
    end

    def compile
      @compiled_templates = {}

      @templates.each do |name, (template, externals)|
        @compiler.compile(template, externals)

        if @compiler.success?
          @compiled_templates[name] = @compiler.code
        else
          @errors.concat @compiler.errors
        end
      end

      success?
    end

    def success?
      @errors.none?
    end

    def render(name, externals={}, storage={})
      if @compiled_templates.nil?
        raise ::RuntimeError, "Call #compile before #render"
      end

      template = @compiled_templates[name]
      if template.nil?
        raise ::ArgumentError, "Template `#{name}' does not exist"
      end

      template.call(externals, storage)
    end

    def render_with_layout(layout_name, layout_externals,
                           template_name, template_externals)
      storage = {}

      template_result = render(template_name, template_externals, storage)
      layout_result   = render(layout_name, layout_externals.
                            merge(_inner_template: template_result), storage)

      layout_result
    end

    def decorate(error)
      decorated = []

      if error.is_a? SourceMappedError
        if error.location
          if file = error.location[:file]
            decorated = error.decorate @sources[file]
          end
        end
      end

      decorated
    end
  end
end