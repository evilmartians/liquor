require 'time'
require 'digest/md5'

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

    function "size", unnamed_arg: [:string, :tuple, :external] do |arg,|
      arg.size
    end

    function "downcase", unnamed_arg: :string do |arg,|
      arg.downcase
    end

    function "upcase", unnamed_arg: :string do |arg,|
      arg.upcase
    end

    function "capitalize", unnamed_arg: :string do |arg,|
      arg.capitalize
    end

    function "md5", unnamed_arg: :string do |arg,|
      Digest::MD5.hexdigest(arg)
    end

    function "url_escape", unnamed_arg: :string do |arg,|
      URI.encode_www_form_component(arg)
    end

    function "truncate",
              unnamed_arg: :string,
              optional_named_args: {
                length:   :integer,
                omission: :string
              } do |arg, kw|
      length   = kw[:length]   || 50
      omission = kw[:omission] || '...'

      truncate_at = length - kw[:omission].length
      truncate_at = 0 if length < 0

      if arg.length > length
        arg[0...truncate_at] + omission
      else
        arg
      end
    end

    function "truncate_words",
              unnamed_arg: :string,
              optional_named_args: {
                words:    :integer,
                omission: :string
              } do |arg, kw|
      words    = arg.split
      length   = kw[:words]    || 15
      omission = kw[:omission] || '...'

      if words.length > length
        words[0...length].join(" ") + omission
      else
        words.join(" ")
      end
    end

    function "strip_newlines", unnamed_arg: :string do |arg,|
      arg.gsub("\n", "")
    end

    function "join", unnamed_arg: :tuple,
                     optional_named_args: { with: :string } do |arg, kw|
      arg.flatten.join(kw[:with] || ' ')
    end

    function "split", unnamed_arg: :string,
                      optional_named_args: { by: :string } do |arg, kw|
      arg.split(kw[:by] || ' ')
    end

    function "replace",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
                replacement: :string
              } do |arg, kw|
      arg.gsub kw[:pattern], kw[:replacement]
    end

    function "replace_first",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
                replacement: :string
              } do |arg, kw|
      arg.sub kw[:pattern], kw[:replacement]
    end

    function "remove",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
              } do |arg, kw|
      arg.gsub kw[:pattern], ''
    end

    function "remove_first",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
              } do |arg, kw|
      arg.sub kw[:pattern], ''
    end

    function "newline_to_br", unnamed_arg: :string do |arg,|
      arg.gsub(/\n/, "<br>\n")
    end

    function "strftime",
              unnamed_arg: :string,
              mandatory_named_args: { format: :string } do |arg, kw|
      begin
        time = Time.parse(arg)
        time.strftime(kw[:format])
      rescue Exception => e
        arg
      end
    end

    function "to_number", unnamed_arg: [:integer, :string] do |arg,|
      if arg.is_a? Integer
        arg
      else
        arg.to_i
      end
    end
    function_alias "to_i", "to_number"

    if [].respond_to? :in_groups_of
      function "in_groups_of",
                unnamed_arg: [:tuple, :external],
                mandatory_named_args: { size: :integer },
                optional_named_args:  { fill_with: :string } do |arg, kw|
        arg.to_a.in_groups_of(kw[:size], kw[:fill_with])
      end

      function "in_groups",
                unnamed_arg: [:tuple, :external],
                mandatory_named_args: { count: :integer },
                optional_named_args:  { fill_with: :string } do |arg, kw|
        arg.to_a.in_groups(kw[:count], kw[:fill_with])
      end
    end

    function "include",
              unnamed_arg: :tuple,
              mandatory_named_args: { element: :any } do |arg, kw|
      arg.include?(kw[:element])
    end

    function "reverse", unnamed_arg: :tuple do |arg,|
      arg.reverse
    end

    function "compact", unnamed_arg: :tuple do |arg,|
      arg.compact
    end

    function "is_even", unnamed_arg: :integer do |arg,|
      (arg % 2) == 0
    end

    function "is_odd", unnamed_arg: :integer do |arg,|
      (arg % 2) == 1
    end

    function "is_empty", unnamed_arg: [:null, :tuple, :external] do |arg,|
      arg.nil? || arg.size == 0
    end

    function "starts_with", unnamed_arg: :string,
                            mandatory_named_args: { pattern: :string } do |arg, kw|
      arg.starts_with?(kw[:pattern])
    end

    function "is_blank", unnamed_arg: [:null, :string] do |arg,|
      arg.nil? || arg.size == 0
    end
  end
end
