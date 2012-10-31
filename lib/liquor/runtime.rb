module Liquor
  module Runtime
    class DummyExternal
      def liquor_send(method, args, loc=nil)
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

    @errors = nil

    def self.capture_errors
      old_errors = @errors
      @errors    = []

      yield

      @errors
    ensure
      @errors    = old_errors
    end

    def self.type_error(klass=TypeError, message, expectation, loc)
      error = klass.new(message, loc)

      if @errors.nil?
        raise error
      else
        @errors << error

        default_value_of expectation
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
        return type_error("Integer, String, Tuple or indexable External value expected, #{pretty_type(left)} found", :null, left_loc)
      end

      left + right
    end

    def self.integer!(value, loc)
      unless value.is_a? Integer
        return type_error("Integer value expected, #{pretty_type(value)} found", :integer, loc)
      end

      value
    end

    def self.string!(value, loc)
      if value.is_a? String
        value
      elsif value.is_a? Integer
        value.to_s
      else
        return type_error("String value expected, #{pretty_type(value)} found", :string, loc)
      end
    end

    # Proper indexable external API:
    # .[](index) => element fetch
    # .size      => element count
    # .to_a      => converts to Array

    def self.tuple!(value, loc)
      unless indexable?(value)
        return type_error("Tuple or indexable External value expected, #{pretty_type(value)} found", :tuple, loc)
      end

      value
    end

    def self.external!(value, loc)
      unless value.is_a? External
        return type_error("External value expected, #{pretty_type(value)} found", :external, loc)
      end

      value
    end

    def self.interp!(value, loc)
      unless value.is_a?(String) ||
             value.is_a?(Integer) ||
             value.nil?
        return type_error("String or Null value expected, #{pretty_type(value)} found", :string, loc)
      end

      value.to_s
    end
  end
end