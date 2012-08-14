module Liquor
  class Emitter
    include ASTTools

    attr_reader :compiler, :context

    def initialize(context)
      @context  = context
      @compiler = context.compiler
      @buffer   = ""
      @current_capture_var = ""
    end

    def env
      '_env'
    end

    def buf
      "_buf#{@current_capture_var}"
    end

    def storage
      "_storage"
    end

    def ident(node)
      name, = nvalue(node)

      case @context.type name
      when :builtin
        case name
        when 'null';  'nil'
        when 'true';  'true'
        when 'false'; 'false'
        end
      when :variable
        @context.access name, nloc(node)
      when :function
        raise NameError.new("using function `#{name}' as a variable", nloc(node))
      when :free
        raise NameError.new("identifier `#{name}' is not bound", nloc(node))
      end
    end

    OPERATORS = {
      :uminus => '-',  :not   => '!',
      :mul    => '*',  :div   => '/',  :mod => '%',
      :plus   => '+',  :minus => '-',
      :eq     => '==', :neq   => '!=',
      :lt     => '<',  :lte   => '<=',
      :gt     => '>',  :gte   => '>=',
      :and    => '&&', :or    => '||',
    }

    def expr(node)
      case ntype(node)
      when :ident
        ident(node)
      when :integer
        integer(node)
      when :string
        string(node)
      when :tuple
        tuple(node)
      when :plus
        plus(node)
      when :mul, :div, :mod, :minus,
           :lt, :lte, :gt, :gte
        integer_binop(node)
      when :uminus
        integer_unop(node)
      when :eq, :neq
        equality_binop(node)
      when :and, :or
        boolean_binop(node)
      when :not
        boolean_unop(node)
      when :index
        index(node)
      when :external
        external(node)
      when :call
        call(node)
      else
        raise "unknown node #{ntype node}"
      end
    end

    def external(node)
      target, method, args = nvalue(node)
      name, = nvalue(method)

      if args
        arg, kw = nvalue(args)

        if arg.nil?
          out_args = [ "nil" ]
        else
          out_args = [ expr(arg) ]
        end

        kw.each do |kwarg, kwval|
          args << "#{kwarg.inspect} => #{expr(kwval)}"
        end
      else
        out_args = []
      end

      "#{check_external(target)}.liquor_send(#{name.inspect}, [ #{out_args.join(", ")} ], #{nloc(method).inspect})"
    end

    def call(node)
      lhs, rhs = nvalue(node)
      name,    = nvalue(lhs)
      arg, kw  = nvalue(rhs)

      if !@context.function? name
        raise NameError.new("undefined function `#{name}'", nloc(lhs))
      end

      function = @context.compiler.function(name)
      if function.unnamed_arg && arg.nil?
        raise ArgumentError.new("unnamed argument is required, but none provided", nloc(rhs))
      elsif !function.unnamed_arg && !arg.nil?
        raise ArgumentError.new("unnamed argument is not accepted, but is provided", nloc(arg))
      else
        function.mandatory_named_args.each do |kwarg,|
          unless kw.include? kwarg
            raise ArgumentError.new("named argument `#{kwarg}' is required, but none provided", nloc(rhs))
          end
        end
        kw.each do |kwarg, kwval|
          if !function.mandatory_named_args.include?(kwarg) &&
             !function.optional_named_args.include?(kwarg)
            raise ArgumentError.new("named argument `#{kwarg}' is not accepted, but is provided", nloc(kwval))
          end
        end
      end

      if arg.nil?
        args = [ "nil" ]
      else
        args = [ expr(arg) ]
      end

      kw = kw.map do |kwarg, kwval|
        "#{kwarg.inspect} => #{expr(kwval)}"
      end
      args << "{ #{kw.join(", ")} }"

      args << nloc(node).inspect

      "@functions[#{name.inspect}].call(#{args.join(', ')})"
    end

    def index(node)
      lhs, rhs = nvalue(node)
      "#{check_tuple(lhs)}[#{check_integer(rhs)}]"
    end

    def plus(node)
      lhs, rhs = nvalue(node)
      "Runtime.add!(#{expr(lhs)}, #{nloc(lhs).inspect}," +
        " #{expr(rhs)}, #{nloc(rhs).inspect})"
    end

    def integer_binop(node)
      lhs, rhs = nvalue(node)
      "#{check_integer(lhs)} #{OPERATORS[ntype(node)]} #{check_integer(rhs)}"
    end

    def integer_unop(node)
      expr, = nvalue(node)
      "#{OPERATORS[ntype(node)]}#{check_integer(expr)}"
    end

    def equality_binop(node)
      lhs, rhs = nvalue(node)
      "#{expr(lhs)} #{OPERATORS[ntype(node)]} #{expr(rhs)}"
    end

    def boolean_binop(node)
      lhs, rhs = nvalue(node)
      "#{convert_boolean(lhs)} #{OPERATORS[ntype(node)]} #{convert_boolean(rhs)}"
    end

    def boolean_unop(node)
      expr, = nvalue(node)
      # converts by itself
      "#{OPERATORS[ntype(node)]}#{expr(expr)}"
    end

    def convert_boolean(node)
      "!!(#{expr(node)})"
    end

    def check_integer(node)
      "Runtime.integer!(#{expr(node)}, #{nloc(node).inspect})"
    end

    def integer(node)
      value, = nvalue(node)
      value
    end

    def check_string(node)
      "Runtime.string!(#{expr(node)}, #{nloc(node).inspect})"
    end

    def string(node)
      value, = nvalue(node)
      value.inspect
    end

    def check_tuple(node)
      "Runtime.tuple!(#{expr(node)}, #{nloc(node).inspect})"
    end

    def tuple(node)
      value, = nvalue(node)
      code = value.map do |elem|
        expr elem
      end.join(", ")
      "[ #{code} ]"
    end

    def check_external(node)
      "Runtime.external!(#{expr(node)}, #{nloc(node).inspect})"
    end

    def check_interp(node)
      "Runtime.interp!(#{expr(node)}, #{nloc(node).inspect})"
    end

    def compile_toplevel(block)
      compile_block(block)

      [
        %!lambda { |_env={}, _storage={}|\n!,
        %|  _buf = ""\n|,
        ([
          %|  |,
          @context.externals.map do |extern|
            @context.access(extern)
          end.join(", "),
          %| = |,
          @context.externals.map do |extern|
            %Q|_env[#{extern.inspect}]|
          end.join(", "),
        ] if @context.externals.any?),
        %|\n|,
        flush!,
        %|  _buf\n|,
        %|}\n|
      ].join
    end

    def compile_block(block)
      block.each do |node|
        case ntype(node)
        when :plaintext
          cat! string(node)

        when :interp
          expr, = nvalue(node)
          cat! check_interp(expr)

        when :tag
          ident, args = nvalue(node)
          name, = nvalue(ident)

          unless @compiler.has_tag? name
            raise NameError.new("undefined tag `#{name}'", nloc(ident))
          end

          @compiler.tag(name).compile(self, node)

        else
          raise "unknown block-level node #{ntype(node)}"
        end
      end
    rescue Liquor::Error => e
      @compiler.add_error e
    end

    def capture
      previous_capture_var = @current_capture_var
      @current_capture_var = @buffer.lines.count.to_s # unique id
      out! %Q{#{buf} = ""\n}

      yield

      buf
    ensure
      @current_capture_var = previous_capture_var
    end

    def cat!(string)
      out! "#{buf} << (#{string})\n"
    end

    def out!(string)
      string = string.gsub /(^|\n)/m, '\1' + ("  " * @context.nesting)
      @buffer.concat string
    end

    def flush!
      @buffer
    ensure
      @buffer = ""
    end
  end
end