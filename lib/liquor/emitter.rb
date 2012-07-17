module Liquor
  class Emitter
    include ASTTools

    def initialize(context)
      @context = context
      @buffer  = ""
    end

    def env
      '_env'
    end

    def buf
      '_buf'
    end

    def ident(node)
      name, = nvalue(node)

      case @context.type name
      when :builtin
        case value
        when 'null';  nil
        when 'true';  true
        when 'false'; false
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
      when :mul, :div, :mod, :plus, :minus,
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
      when :access
        access(node)
      when :call
        call(node)
      else
        raise "unknown node #{ntype node}"
      end
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
        function.mandatory_named_args.each do |kwarg|
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

      kw.each do |kwarg, kwval|
        args << "#{kwarg.inspect} => #{expr(kwval)}"
      end

      "@functions[#{name.inspect}].call(#{args.join(', ')})"
    end

    def index(node)
      lhs, rhs = nvalue(node)
      "#{check_tuple(lhs)}[#{check_integer(rhs)}]"
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
      "#{OPERATORS[ntype(node)]}#{(expr)}"
    end

    def convert_boolean(node)
      "(!!#{expr(node)})"
    end

    def check_integer(node)
      "Runtime.integer!(#{expr(node)})"
    end

    def integer(node)
      value, = nvalue(node)
      value
    end

    def check_string(node)
      "Runtime.string!(#{expr(node)})"
    end

    def string(node)
      value, = nvalue(node)
      value.inspect
    end

    def check_tuple(node)
      "Runtime.tuple!(#{expr(node)})"
    end

    def tuple(node)
      value, = nvalue(node)
      code = value.map do |elem|
        expr elem
      end.join(", ")
      "[ #{code} ]"
    end

    def check_external(node)
      "Runtime.external!(#{expr(node)})"
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