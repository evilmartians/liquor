require 'date'

module Liquor
  module External
    module ClassMethods
      def export(*methods)
        unless @liquor_exports
          @liquor_exports      = superclass.liquor_exports.dup
          @liquor_deprecations = superclass.liquor_deprecations.dup
        end

        @liquor_exports.merge methods
      end

      def deprecate(*args)
        options = {}
        options = args.delete_at(-1) if args[-1].is_a? Hash

        if (missing = [:date, :message] - options.keys).any?
          raise ::ArgumentError, "A call to Liquor::External#deprecate misses " <<
                                 "mandatory arguments: #{missing.join(", ")}"
        elsif (extra = options.keys - [:date, :message]).any?
          raise ::ArgumentError, "A call to Liquor::External#deprecate has " <<
                                 "extraneous arguments: #{missing.join(", ")}"
        end

        options = {
          date:    Date.parse(options[:date]),
          message: options[:message].to_s
        }.freeze

        args.each do |export|
          @liquor_deprecations[export] = options
        end
      end
    end

    def self.included(klass)
      klass.instance_exec do
        class << self
          attr_reader :liquor_exports
          attr_reader :liquor_deprecations
        end

        @liquor_exports      = Set[]
        @liquor_deprecations = {}

        extend ClassMethods
      end
    end

    def liquor_send(method, args, loc=nil)
      method = method.to_sym

      if self.class.liquor_exports.include?(method)
        if (deprecation = self.class.liquor_deprecations[method])
          Liquor::Runtime.deprecation(
              "`#{method}' is deprecated and will be removed after " <<
              "#{deprecation[:date]}: #{deprecation[:message]}", loc)
        end

        begin
          send method, *args
        rescue ::Liquor::Diagnostic => e
          raise e
        rescue ::Exception => e
          # First, remove the caller backtrace at the following line.
          # This will not include the line in liquor_send which will
          # be in the host exception backtrace. Second, remove that one.
          host_backtrace = (e.backtrace - caller)[0..-2]

          raise HostError.new(nil, e, host_backtrace, loc)
        end
      else
        raise ArgumentError.new("undefined external method #{method} for #{self.class}", loc)
      end
    end
  end
end
