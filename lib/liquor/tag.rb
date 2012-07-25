module Liquor
  class Tag
    include ASTTools

    attr_reader :name

    def initialize(name, &block)
      @name = name.to_s
      @body = block

      if @body.nil?
        raise "Cannot define a tag without body"
      end
    end

    def compile(emit, node)
      instance_exec emit, emit.context, node, &@body
    end

    def check_args(node, arg_type, kwarg_types)
      name, arg, *kwargs = nvalue(node)
      if arg_type.nil? && !arg.nil?
        raise SyntaxError.new("extraneous argument", nloc(arg))
      elsif !arg_type.nil? && arg.nil?
        raise SyntaxError.new("missing unnamed argument", nloc(node))
      end

      kwarg_hash = {}

      kwarg_types.zip(kwargs).each do |(name, type), kwarg|
        if kwarg.nil?
          raise SyntaxError.new("unexpected `%}', expecting `#{name}'", nloc(node))
        elsif kwname(kwarg) != name.to_s
          raise SyntaxError.new("unexpected `#{kwname(kwarg)}', expecting `#{name}'", nloc(kwarg))
        end

        check_arg_type(kwarg, type)

        kwarg_hash[name] = kwvalue(kwarg)
      end

      [ arg, kwarg_hash ]
    end

    def check_arg_type(node, type)
      expected = nil

      case ntype(node)
      when :kwarg
        actual = ntype(kwvalue(node))
      when :blockarg
        actual = :block
      end

      case type
      when :ident
        expected = :ident
        failed = (actual != expected)

      when :expr
        expected = :expression
        failed = (actual == :block)

      when :block
        expected = :block
        failed = (actual != expected)

      else
        raise "Unknown node type #{type}"
      end

      if failed
        actual   = Parser::TOKEN_NAME_MAP[actual] || actual
        expected = Parser::TOKEN_NAME_MAP[expected] || expected
        raise SyntaxError.new("unexpected `#{actual}', expecting `#{expected}'", nloc(node))
      end
    end
  end
end