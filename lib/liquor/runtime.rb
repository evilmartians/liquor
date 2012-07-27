module Liquor
  module Runtime
    def self.add!(left, right)
    end

    def self.integer!(value)
      if value.is_a? Integer
        value
      else
        raise TypeError.new("not integer")
      end
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
      if value.is_a? Array
        value
      else
        raise TypeError.new("tuple expected")
      end
    end
  end
end