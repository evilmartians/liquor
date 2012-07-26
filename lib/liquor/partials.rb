module Liquor
  module Partials
    include Library

    tag "yield" do |emit, context, node|
      arg, kw = check_args node,
          :ident

      name, = nvalue(arg)

      emit.cat! %Q|#{emit.storage}[#{name.inspect}].to_s|
    end

    tag "content_for" do |emit, context, node|
      arg, kw = check_args node,
          :ident,
          :"capture" => :block

      name, = nvalue(arg)
      block = kw[:"capture"]

      context.nest do
        capture_var_name = emit.capture do
          emit.compile_block block
        end

        emit.out! %Q|#{emit.storage}[#{name.inspect}] = #{capture_var_name}\n|
      end
    end

    tag "include" do |emit, context, node|
      tag_name, partial, *kwargs = nvalue(node)

      check_arg_type partial, :expr

      kwarg_exprs = {}
      kwargs.each do |kwarg|
        if kwarg_exprs.include? kwname(kwarg)
          raise SyntaxError.new("duplicate keyword argument `#{kwname(kwarg)}'", nloc(kwarg))
        end

        check_arg_type(kwarg, :expr)

        kwarg_exprs[kwname(kwarg)] = kwvalue(kwarg)
      end

      arguments = kwarg_exprs.map do |name, value|
        %Q|:"#{name}" => #{emit.expr(value)}|
      end.join(", ")
      emit.cat! %Q|@manager.fetch(#{emit.check_string(partial)}).call(#{arguments})|
    end
  end
end