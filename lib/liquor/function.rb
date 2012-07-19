module Liquor
  class Function
    attr_reader :name
    attr_reader :unnamed_arg
    attr_reader :mandatory_named_args, :optional_named_args
    attr_reader :call

    def initialize(name, options={}, &block)
      @name = name.to_s

      @unnamed_arg          = options.delete(:unnamed_arg)
      @mandatory_named_args = options.delete(:mandatory_named_args).
                                  to_a.map(&:to_sym)
      @optional_named_args  = options.delete(:optional_named_args).
                                  to_a.map(&:to_sym)
      @body                 = block

      if @body.nil?
        raise "Cannot define a function without body"
      elsif options.any?
        raise "Unknown function options: #{options.keys.join ", "}"
      end
    end

    def call(arg=nil, kw={})
      @body.call(arg, kw)
    end
  end
end