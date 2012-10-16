module Liquor
  module Partials
    include Library

    tag "yield" do |emit, context, node|
      tag, arg, *kwargs = nvalue(node)

      if arg.nil? # {% yield %}
        check_args node,
            nil

        emit.cat! context.access('_inner_template')
      else
        if kwargs.count == 0
          # {% yield "name" %}
          arg, kw = check_args node,
              :string

          name, = nvalue(arg)

          emit.cat! %Q|#{emit.storage}[#{name.inspect}].to_s|
        else
          # {% yield "name" if_none: %} block {% end yield %}
          arg, kw = check_args node,
              :string,
              :if_none => :block

          name, = nvalue(arg)

          emit.out! %Q|if #{emit.storage}.include?(#{name.inspect})\n|
          emit.cat! %Q|  #{emit.storage}[#{name.inspect}].to_s|
          emit.out! %Q|else\n|
          emit.compile_block kw[:if_none]
          emit.out! %Q|end\n|
        end
      end
    end

    tag "content_for" do |emit, context, node|
      arg, kw = check_args node,
          :string,
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
      arg, kw = check_args node,
          :string

      name, = nvalue(arg)

      context.nest do
        manager = context.compiler.manager

        source = manager.fetch_partial "_#{name}"
        if source.nil?
          raise ArgumentError.new("partial `#{name}' does not exist", nloc(arg))
        elsif source == :syntax_error
          raise PartialError.new("partial `#{name}' contains a syntax error", nloc(arg))
        end

        emit.compile_block source
      end
    end
  end
end