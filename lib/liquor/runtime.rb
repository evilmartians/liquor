module Liquor
  module Runtime
    class DummyExternal
      def liquor_send(method, args, loc=nil)
        nil
      end

      def source
        nil
      end
    end

    def self.type(value)
      case value
      when nil;         :null
      when true, false; :boolean
      when Integer;     :integer
      when String;      :string
      when Array;       :tuple
      when External;    :external
      else;             :invalid
      end
    end

    def self.pretty_type(value)
      case value
      when nil;         "Null"
      when true, false; "Boolean"
      when Integer;     "Integer"
      when String;      "String"
      when Array;       "Tuple"
      when External;    indexable?(value) ? "IndexableExternal" : "External"
      else              "_Foreign<#{value.class}>"
      end
    end

    def self.default_value_of(type)
      case type
      when :null;     nil
      when :boolean;  false
      when :integer;  0
      when :string;   ""
      when :tuple;    []
      when :external; DummyExternal.new
      end
    end

    @diagnostics = nil

    def self.capture_diagnostics
      old_diagnostics = @diagnostics
      @diagnostics    = []

      yield

      @diagnostics
    ensure
      @diagnostics    = old_diagnostics
    end

    @fatal_deprecations = false

    def self.with_fatal_deprecations
      old_fatal_deprecations = @fatal_deprecations
      @fatal_deprecations    = true

      yield
    ensure
      @fatal_deprecations    = old_fatal_deprecations
    end

    def self.soft_error(klass=TypeError, message, expectation, loc)
      error = klass.new(message, loc)

      if @diagnostics.nil?
        raise error
      else
        error.set_backtrace(caller(2))
        @diagnostics << error

        default_value_of expectation
      end
    end

    def self.deprecation(message, loc)
      error = Liquor::Deprecation.new(message, loc)
      error.set_backtrace(caller(2))

      if @fatal_deprecations
        raise error
      elsif @diagnostics
        @diagnostics << error
      end
    end

    def self.indexable?(value)
      value.is_a?(Array) ||
        value.is_a?(External) &&
        value.class.liquor_exports &&
        value.class.liquor_exports.include?(:[])
    end

    def self.add!(left, left_loc, right, right_loc)
      if left.is_a? Integer
        right = integer! right, right_loc
      elsif left.is_a? String
        right = string! right, right_loc
      elsif indexable?(left)
        left  = left.to_a
        right = tuple! right, right_loc
      else
        return soft_error("Integer, String, Tuple or indexable External value expected, #{pretty_type(left)} found", :null, left_loc)
      end

      left + right
    end

    def self.integer!(value, loc)
      unless value.is_a? Integer
        return soft_error("Integer value expected, #{pretty_type(value)} found", :integer, loc)
      end

      value
    end

    def self.string!(value, loc)
      if value.is_a? String
        value
      elsif value.is_a? Integer
        value.to_s
      else
        return soft_error("String value expected, #{pretty_type(value)} found", :string, loc)
      end
    end

    # Proper indexable external API:
    # .[](index) => element fetch
    # .size      => element count
    # .to_a      => converts to Array

    def self.tuple!(value, loc)
      unless indexable?(value)
        return soft_error("Tuple or indexable External value expected, #{pretty_type(value)} found", :tuple, loc)
      end

      value
    end

    def self.external!(value, loc)
      unless value.is_a? External
        return soft_error("External value expected, #{pretty_type(value)} found", :external, loc)
      end

      value
    end

    def self.interp!(value, loc)
      unless value.is_a?(String) ||
             value.is_a?(Integer) ||
             value.nil?
        return soft_error("String or Null value expected, #{pretty_type(value)} found", :string, loc)
      end

      value.to_s
    end
  end
end
