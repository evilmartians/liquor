module Liquor
  module Runtime
    def self.indexable?(value)
      value.is_a?(Array) ||
        value.is_a?(External) &&
        value.class.liquor_exports &&
        value.class.liquor_exports.include?(:[])
    end

    def self.add!(left, left_loc, right, right_loc)
      if left.is_a? Integer
        integer! right, right_loc
      elsif left.is_a? String
        string! right, right_loc
      elsif indexable?(left)
        left = left.to_a
        tuple! right, right_loc
      else
        raise TypeError.new("Integer, String, Tuple or indexable External value expected, #{type(left)} found", left_loc)
      end

      left + right
    end

    def self.integer!(value, loc)
      unless value.is_a? Integer
        raise TypeError.new("Integer value expected, #{type(value)} found", loc)
      end

      value
    end

    def self.string!(value, loc)
      if value.is_a? String
        value
      elsif value.is_a? Integer
        value.to_s
      else
        raise TypeError.new("String value expected, #{type(value)} found", loc)
      end
    end

    # Proper indexable external API:
    # .[](index) => element fetch
    # .size      => element count
    # .to_a      => converts to Array

    def self.tuple!(value, loc)
      unless indexable?(value)
        raise TypeError.new("Tuple or indexable External value expected, #{type(value)} found", loc)
      end

      value
    end

    def self.external!(value, loc)
      unless value.is_a? External
        raise TypeError.new("External value expected, #{type(value)} found", loc)
      end

      value
    end

    def self.interp!(value, loc)
      unless value.is_a?(String) ||
             value.is_a?(Integer) ||
             value.nil?
        raise TypeError.new("String or Null value expected, #{type(value)} found", loc)
      end

      value.to_s
    end

    def self.type(value)
      case value
      when nil;         "Null"
      when true, false; "Boolean"
      when Integer;     "Integer"
      when String;      "String"
      when Array;       "Tuple"
      when External;    "External"
      else              "_Foreign<#{value.class}>"
      end
    end
  end
end