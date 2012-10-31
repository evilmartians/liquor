module Liquor
  class Function
    attr_reader :name
    attr_reader :unnamed_arg
    attr_reader :mandatory_named_args, :optional_named_args
    attr_reader :call

    def initialize(name, options={}, &block)
      @name = name.to_s

      options = options.dup
      @unnamed_arg          = options.delete(:unnamed_arg)
      @mandatory_named_args = (options.delete(:mandatory_named_args) || {}).to_hash
      @optional_named_args  = (options.delete(:optional_named_args) || {}).to_hash
      @body                 = block

      if @body.nil?
        raise "Cannot define a function without body"
      elsif options.any?
        raise "Unknown function options: #{options.keys.join ", "}"
      end
    end

    def alias(new_name)
      self.class.new(new_name, {
        unnamed_arg: @unnamed_arg,
        mandatory_named_args: @mandatory_named_args,
        optional_named_args: @optional_named_args,
      }, &@body)
    end

    def check_type(name, arg, expected_type, loc)
      actual_type  = Runtime.type arg
      check_failed = false

      case expected_type
      when :any
        check_failed = (actual_type == :invalid)
      when :null, :boolean, :string, :integer, :tuple, :external
        check_failed = (actual_type != expected_type)
      when Array
        check_failed = !expected_type.include?(actual_type)
      else
        raise "Invalid type specifier: #{expected_type.inspect}"
      end

      if check_failed &&
            Array(expected_type).include?(:tuple) &&
            Runtime.indexable?(arg)
        check_failed = false
      end

      if check_failed
        expected = Array(expected_type).map(&:capitalize).join(", ")

        Runtime.type_error(ArgumentTypeError,
                    "#{expected} value expected, #{Runtime.pretty_type arg} found",
                    Array(expected_type).first,
                    { function: @name, argument: name }.merge(loc))
      else
        arg
      end
    end

    def call(arg=nil, kw={}, loc={})
      arg = check_type nil, arg, @unnamed_arg, loc if @unnamed_arg

      @mandatory_named_args.each do |name, type|
        kw[name] = check_type name, kw[name], type, loc
      end

      @optional_named_args.each do |name, type|
        kw[name] = check_type name, kw[name], type, loc if kw.has_key?(name)
      end

      @body.call(arg, kw)
    end
  end
end