module Liquor
  module Builtins
    include Library

    tag "declare" do |emit, context, node|
      arg, kw = check_args node,
          :ident,
          :"=" => :expr

      var_name, = nvalue(arg)
      expr      = kw[:"="]

      context.declare var_name, nloc(arg)

      emit.out! %Q|#{context.access(var_name)} = #{emit.expr(expr)}\n|
    end

    tag "assign" do |emit, context, node|
      arg, kw = check_args node,
          :ident,
          :"=" => :expr

      var_name, = nvalue(arg)
      expr      = kw[:"="]

      unless context.variable? var_name
        context.declare var_name, nloc(arg)
      end

      emit.out! %Q|#{context.access(var_name)} = #{emit.expr(expr)}\n|
    end

    class ForLoop
      include Liquor::External

      def initialize(length)
        @length = length
        @index  = 0
      end

      attr_reader   :length
      attr_accessor :index

      def next!
        @index += 1
      end

      def rindex
        @length - @index - 1
      end

      def is_first
        @index == 0
      end

      def is_last
        @index == @length - 1
      end

      export :length, :index, :rindex, :is_first, :is_last
    end

    tag "for" do |emit, context, node|
      name, arg, *kwargs = nvalue(node)

      if kwargs.empty?
        raise SyntaxError.new("unexpected end of tag, expecting one of: `in:', `from:'.", nloc(node))
      elsif kwname(kwargs[0]) == 'in'
        arg, kw = check_args node,
            :ident,
            :in => :expr,
            :do => :block
      elsif kwname(kwargs[0]) == 'from'
        arg, kw = check_args node,
            :ident,
            :from => :expr,
            :to   => :expr,
            :do   => :block
      else
        raise SyntaxError.new("unexpected `#{kwname(kwargs[0])}:', expecting one of: `in:', `from:'.", nloc(kwargs[0]))
      end

      var_name,    = nvalue(arg)
      indexer_name = "#{var_name}_loop"

      context.nest do
        context.declare var_name, nloc(arg)
        context.declare indexer_name

        if kw[:in]
          emit.out! %Q|#{context.access indexer_name} = Liquor::Builtins::ForLoop.new(#{emit.check_tuple(kw[:in])}.size)\n|
          emit.out! %Q|for #{context.access(var_name)} in #{emit.check_tuple(kw[:in])}\n|
        elsif kw[:from]
          emit.out! %Q|#{context.access indexer_name} = Liquor::Builtins::ForLoop.new(#{emit.check_integer(kw[:to])} - #{emit.check_integer(kw[:from])})\n|
          emit.out! %Q<#{emit.check_integer(kw[:from])}.upto(#{emit.check_integer(kw[:to])}) do |#{context.access(var_name)}|\n>
        end

        emit.compile_block kw[:do]

        emit.out! %Q|#{context.access indexer_name}.next!\n|
        emit.out! %Q|end\n|
      end
    end

    tag "if", continuations: %w(elsif) do |emit, context, node|
      tag_name, arg, *kwargs = nvalue(node)

      state = :begin
      while state
        case state
        when :begin
          if arg.nil?
            if kwargs.empty?
              raise SyntaxError.new("unexpected end of tag, expecting `expression'", nloc(node))
            else
              raise SyntaxError.new("unexpected `#{kwname(kwargs[0])}:', expecting `expression'", nloc(kwargs[0]))
            end
          end

          emit.out! %Q|if #{emit.convert_boolean(arg)}\n|
          state = :then

        when :elsif
          kwarg = kwargs.shift

          if kwarg.nil?
            state = nil
          elsif kwname(kwarg) == 'elsif'
            check_arg_type(kwarg, :expr)

            emit.out! %Q|elsif #{emit.convert_boolean(kwvalue(kwarg))}\n|
            state = :then
          elsif kwname(kwarg) == 'else'
            check_arg_type(kwarg, :block)

            emit.out! %Q|else\n|
            emit.compile_block kwvalue(kwarg)
            state = :end
          else
            raise SyntaxError.new("unexpected `#{kwname(kwarg)}', expecting one of: `elsif:', `else:'")
          end

        when :then
          kwarg = kwargs.shift
          if kwarg.nil?
            raise SyntaxError.new("unexpected end of tag, expecting `then:'", nloc(node))
          elsif kwname(kwarg) != 'then'
            raise SyntaxError.new("unexpected `#{kwname(kwarg)}', expecting `then:'", nloc(kwarg))
          end

          check_arg_type(kwarg, :block)

          emit.compile_block kwvalue(kwarg)
          state = :elsif

        when :end
          if kwargs.any?
            raise SyntaxError.new("unexpected `#{kwname(kwargs.first)}', expecting end of tag", nloc(kwarg))
          end

          state = nil
        end
      end

      emit.out! %Q|end\n|
    end

    tag "unless" do |emit, context, node|
      arg, kw = check_args node,
          :expr,
          :then => :block

      emit.out! %Q|unless #{emit.convert_boolean(arg)}\n|
      emit.compile_block kw[:then]
      emit.out! %Q|end\n|
    end

    tag "capture" do |emit, context, node|
      arg, kw = check_args node,
          :ident,
          :"=" => :block

      var_name, = nvalue(arg)
      block     = kw[:"="]

      context.declare var_name, nloc(arg)
      access_var_name = context.access(var_name)

      context.nest do
        capture_var_name = emit.capture do
          emit.compile_block block
        end

        emit.out! %Q|#{access_var_name} = #{capture_var_name}\n|
      end
    end

  end
end
