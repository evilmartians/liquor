require 'rails'
require 'liquor/drop/drop'

module Liquor
  module Pagination
    include Library

    # Usage:

=begin
{% pagination start: %}
<div class='digg_pagination'>
  {% if page.is_current then: %}
  <span class="disabled previous_page">&#8592; Previous</span>
  {% else %}
  <a href="{{ previous_page_url }}" rel="previous" class="previous_page_page">&#8592; Previous</a>
  {% end if %}
{% page: %}
  {% if page.is_current then: %}
  <em class="current">{{ page.number }}</em>
  {% elsif page.is_next then: %}
  <a href="{{ page.url }}" rel="next">{{ page.number }}</a>
  {% elsif page.is_prev then: %}
  <a href="{{ page.url }}" rel="previous">{{ page.number }}</a>
  {% else %}
  <a href="{{ page.url }}">3</a>
  {% end if %}
{% gap: %}
  <span class="gap">&hellip;</span>
{% end: %}
  {% if page.is_current then: %}
  <span class="disabled next_page">Next &#8594;</span>
  {% else %}
  <a href="{{ next_page_url }}" rel="next" class="next_page">Next &#8594;</a></div>
  {% end if %}
{% end pagination %}
=end

    class UrlGenerator
      def self.bootstrap
        unless @bootstrapped
          include Rails.application.routes.url_helpers
          @bootstrapped = true
        end

        self
      end

      cattr_accessor :default_url_options
      self.default_url_options = {}
    end

    class PageExternal
      include Liquor::External

      def initialize(collection, options={})
        @collection = collection
        @options    = options
        @index      = @collection.current_page
      end

      def is_current
        @index == @collection.current_page
      end

      def is_first
        @index == 1
      end

      def is_last
        @index == @collection.total_pages - 1
      end

      def is_prev
        @index == @collection.current_page - 1
      end

      def is_next
        @index == @collection.current_page + 1
      end

      export :is_current, :is_first, :is_last, :is_prev, :is_next

      def in_inner_window
        (@collection.current_page - @index).abs <= @options[:inner_window]
      end

      def in_outer_window
        @index <= @options[:outer_window] ||
            @collection.total_pages - @index < @options[:outer_window]
      end

      def is_gap
        !in_outer_window && !in_inner_window
      end

      export :in_inner_window, :in_outer_window, :is_gap

      def with(index)
        @index = index
        self
      end

      def each_relevant_page
        relevant_pages.each do |page|
          with(page); yield
        end
      end

      def relevant_pages
        left_window_plus_one = 1.upto(@options[:outer_window] + 1).to_a
        right_window_plus_one = (@collection.total_pages - @options[:outer_window]).upto(@collection.total_pages).to_a
        inside_window_plus_each_sides = (@collection.current_page - @options[:inner_window] - 1).upto(@collection.current_page + @options[:inner_window] + 1).to_a

        (left_window_plus_one + inside_window_plus_each_sides + right_window_plus_one).uniq.sort.reject {|x| (x < 1) || (x > @collection.total_pages)}
      end

      def path
        @url_generator ||= UrlGenerator.bootstrap.new

        if @collection.respond_to? :to_page_path
          @collection.to_page_path(@url_generator, @index)
        elsif @collection.is_a? ActiveRecord::Relation
          @url_generator.polymorphic_path(@collection.klass, page: @index)
        else
          raise "Don't know how to generate page path for #{@collection.class}"
        end
      end
      export :path
    end

    class Scope < Liquor::Drop::Scope
      def total_entries
        @source.total_count
      end

      def per_page(size)
        @source.per(size).to_drop
      end

      export :total_entries, :per_page
    end

    tag "pagination" do |emit, context, node|
      arg, kw = check_args node,
          nil,
          :"start" => :block,
          :"page"  => :block,
          :"gap"   => :block,
          :"end"   => :block

      context.nest do
        context.declare :page

        options    = context.access(:options)
        collection = context.access(:collection)
        page       = context.access(:page)

        emit.out! %Q|#{page} = Liquor::Pagination::PageExternal.new(#{collection}, #{options})\n|

        { :first_page_path => '1',
          :last_page_path  => "#{collection}.total_pages - 1",
          :next_page_path  => "#{collection}.current_page + 1",
          :prev_page_path  => "#{collection}.current_page - 1",
        }.each do |var, value|
          context.declare var
          emit.out! %Q|#{context.access(var)} = #{page}.with(#{value}).path\n|
        end

        [ :current_page, :total_pages ].each do |var|
          context.declare var
          emit.out! %Q|#{context.access(var)} = #{collection}.#{var}\n|
        end

        emit.out! %Q|#{page}.with(1)\n|
        emit.compile_block kw[:start]

        emit.out! %Q|#{page}.each_relevant_page do\n|
        emit.out! %Q|  if #{page}.is_gap\n|
        emit.compile_block kw[:gap]
        emit.out! %Q|  else\n|
        emit.compile_block kw[:page]
        emit.out! %Q|  end\n|
        emit.out! %Q|end\n|

        emit.out! %Q|#{page}.with(#{collection}.total_pages - 1)\n|
        emit.compile_block kw[:end]
      end
    end

    # {% paginate posts %}

    tag "paginate" do |emit, context, node|
      name, collection, *kwargs = nvalue(node)
      check_arg_type(collection, :expr)

      valid_kws = %w[inner_window outer_window]

      kw = Hash[kwargs.map do |kwarg|
        check_arg_type(kwarg, :expr)

        name, value = kwname(kwarg), kwvalue(kwarg)
        if !valid_kws.include?(name)
          raise SyntaxError.new("unexpected `#{name}', expecting one of #{valid_kws.
                                 map { |kw| "`#{kw}'" }.join(", ")}", nloc(kwarg))
        end

        [ name, value ]
      end]

      context.nest do
        context.declare :collection
        emit.out! %Q|#{context.access(:collection)} = #{emit.check_external(collection)}.source\n|

        inner_window = kw[:inner_window] ? emit.check_integer(kw[:inner_window]) : '2'
        outer_window = kw[:outer_window] ? emit.check_integer(kw[:outer_window]) : '0'

        context.declare :options
        emit.out! %Q|#{context.access(:options)} = {
            inner_window: #{inner_window},
            outer_window: #{outer_window}
          }\n|

        manager = context.compiler.manager

        source = manager.fetch_partial "_pagination"
        if source.nil?
          raise ArgumentError.new("partial `pagination' does not exist", nloc(arg))
        end

        emit.compile_block source
      end
    end
  end
end