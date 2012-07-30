require 'time'

module Liquor
  module Builtins
    include Library

    tag "assign" do |emit, context, node|
      arg, kw = check_args node,
          :ident,
          :"=" => :expr

      var_name, = nvalue(arg)
      expr      = kw[:"="]

      context.declare var_name, nloc(arg)

      emit.out! %Q|#{context.access(var_name)} = #{emit.expr(expr)}\n|
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

      var_name, = nvalue(arg)

      context.nest do
        context.declare var_name, nloc(arg)

        if kw[:in]
          emit.out! %Q|for #{context.access(var_name)} in #{emit.check_tuple(kw[:in])}\n|
        elsif kw[:from]
          emit.out! %Q<#{emit.check_integer(kw[:from])}.upto(#{emit.check_integer(kw[:to])}) do |#{context.access(var_name)}|\n>
        end

        emit.compile_block kw[:do]

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

    function "size", unnamed_arg: [:string, :tuple] do |arg,|
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

    function "escape", unnamed_arg: :string do |arg,|
      URI.encode_www_form_component(arg)
    end
    function_alias "url_escape", "escape"

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
                     optional_named_args: { glue: :string } do |arg, kw|
      arg.flatten.join(kw[:glue] || ' ')
    end

    function "split", unnamed_arg: :string,
                      optional_named_args: { delimiter: :string } do |arg, kw|
      arg.split(kw[:delimiter] || ' ')
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

    function "date",
              unnamed_arg: :string,
              mandatory_named_args: { format: :string } do |arg, kw|
      begin
        time = Time.parse(arg)
        time.strftime(kw[:format])
      rescue Exception => e
        raise e
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
                unnamed_arg: :tuple,
                mandatory_named_args: { number: :integer },
                optional_named_args:  { fill_with: :string } do |arg, kw|
        arg.in_groups_of(kw[:size], kw[:fill_with])
      end

      function "in_groups",
                unnamed_arg: :tuple,
                mandatory_named_args: { number: :integer },
                optional_named_args:  { fill_with: :string } do |arg, kw|
        arg.in_groups(kw[:size], kw[:fill_with])
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

    function "even", unnamed_arg: :integer do |arg,|
      (arg % 2) == 0
    end

    function "odd", unnamed_arg: :integer do |arg,|
      (arg % 2) == 1
    end
  end
end