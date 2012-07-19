module Liquor
  module Builtins
    include Library

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
  end
end