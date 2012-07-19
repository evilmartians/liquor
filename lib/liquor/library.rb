module Liquor
  module Library
    def self.included(klass)
      klass.instance_exec {
        extend ModuleMethods

        @functions = []
      }
    end

    module ModuleMethods
      def export(compiler)
        @functions.each do |function|
          compiler.register_function function
        end
      end

      def function(name, options={}, &block)
        @functions << Function.new(name, options, &block)
      end
    end
  end
end