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

    def liquor_send(method, args, loc=nil)
      if self.class.liquor_exports.include?(method.to_sym)
        begin
          send method, *args
        rescue ::Liquor::Error => e
          raise e
        rescue ::Exception => e
          # First, remove the caller backtrace at the following line.
          # This will not include the line in liquor_send which will
          # be in the host exception backtrace. Second, remove that one.
          host_backtrace = (e.backtrace - caller)[0..-2]

          raise HostError.new(e.message, e, host_backtrace, loc)
        end
      else
        raise ArgumentError.new("undefined external method #{method} for #{self.class}", loc)
      end
    end
  end
end