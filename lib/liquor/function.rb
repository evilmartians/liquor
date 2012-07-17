module Liquor
  class Function
    attr_reader :name

    def initialize(name, &block)
      @name = name.to_s

      @unnamed_arg          = nil
      @mandatory_named_args = nil
      @optional_named_args  = nil
      @body                 = nil

      instance_exec &block

      unless @body
        raise "cannot define a function without body"
      end
    end

    # Getters/setters

    def unnamed_arg(value=nil)
      if value.nil?
        @unnamed_arg || false
      elsif !@unnamed_arg.nil?
        raise "cannot redefine unnamed_arg"
      else
        @unnamed_arg = value
      end
    end

    def mandatory_named_args(*values)
      if values.none?
        @mandatory_named_args || []
      elsif !@mandatory_named_args.nil?
        raise "cannot redefine mandatory_named_args"
      else
        @mandatory_named_args = values
      end
    end

    def optional_named_args(*values)
      if values.none?
        @optional_named_args || []
      elsif !@optional_named_args.nil?
        raise "cannot redefine optional_named_args"
      else
        @optional_named_args = values
      end
    end

    def body(&block)
      if block.nil?
        @body
      elsif !@body.nil?
        raise "cannot redefine body"
      else
        @body = block
      end
    end

    # Calling

    def call(arg=nil, kw={})
      @body.call(arg, kw)
    end
  end
end