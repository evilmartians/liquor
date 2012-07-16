module Liquor
  class Compiler
    include ASTTools

    attr_reader :errors, :code

    def initialize
      @parser = Parser.new
      @errors = []
      @code   = nil
    end

    # External API

    def register_tag(tag)
      # TODO
    end

    def register_function(function)
      # TODO
    end

    def compile(source, externals=[])
      @errors.clear

      externals = externals.map(&:to_sym)

      @parser.parse source
      if @parser.ast
        context = Liquor::Context.new(externals)
        code = compile_block(@parser.ast, context)
        if success?
          @code = finalize(code, context)
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

    def success?
      errors.empty?
    end

    def parse_tree
      @parser.ast
    end

    # Internal API

    def finalize(inside_code, context)
      wrapper = [
        %!lambda { |_env={}|\n!,
        %|  _buf = ""\n|,
        ([
          %|  |,
          context.externals.map do |extern|
            context.access(extern)
          end.join(", "),
          %| = |,
          context.externals.map do |extern|
            %Q|_env[#{extern.inspect}]|
          end.join(", "),
        ] if context.externals.any?),
        %|\n|,
        inside_code,
        %|}\n|
      ].join

      eval(wrapper, nil, '(liquor)')
    end

    def compile_block(block, context)
      code = ""
      block.each do |node|
        case ntype(node)
        when :plaintext
          text, = nvalue(node)
          code << %Q|_buf << #{text.inspect}\n|

        else
          raise "unknown block-level node #{ntype(node)}"
        end
      end

      code.gsub! /(^|\n)/m, '\1' + ("  " * context.nesting)
      code
    end
  end
end