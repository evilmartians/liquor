module Liquor
  module Runtime
    def self.add!(left, right)
      if left.is_a? Integer
        integer! right
      elsif left.is_a? String
        string! right
      elsif left.is_a? Array
        tuple! right
      else
        raise TypeError.new("integer, string or tuple expected")
      end

      left + right
    end

    def self.integer!(value)
      raise TypeError.new("integer expected") unless value.is_a? Integer
      value
    end

    def self.string!(value)
      if value.is_a? String
        value
      elsif value.is_a? Integer
        value.to_s
      else
        raise TypeError.new("string expected")
      end
    end

    def self.tuple!(value)
      raise TypeError.new("tuple expected") unless value.is_a? Array
      value
    end
  end
end