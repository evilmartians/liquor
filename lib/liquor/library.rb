module Liquor
  module Library
    def self.included(klass)
      klass.instance_exec {
        extend ModuleMethods

        @functions = []
        @tags      = []
      }
    end

    module ModuleMethods
      def export(compiler)
        @functions.each do |function|
          compiler.register_function function
        end

        @tags.each do |tag|
          compiler.register_tag tag
        end
      end

      def function(name, options={}, &block)
        @functions << Function.new(name, options, &block)
      end

      def tag(name, options={}, &block)
        @tags << Tag.new(name, options, &block)
      end
    end
  end
end