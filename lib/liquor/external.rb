module Liquor
  module External
    module ClassMethods
      def export(*methods)
        unless @liquor_exports
          @liquor_exports = superclass.liquor_exports.dup
        end

        @liquor_exports.merge methods
      end
    end

    def self.included(klass)
      klass.instance_exec do
        class << self
          attr_reader :liquor_exports
        end
        @liquor_exports = Set[]

        extend ClassMethods
      end
    end

    def liquor_send(method, *args)
      if self.class.liquor_exports.include?(method.to_sym)
        send method, *args
      else
        raise "unexported external method #{method}"
      end
    end
  end
end