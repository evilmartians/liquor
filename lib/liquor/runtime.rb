module Liquor
  module Runtime
    def self.integer!(value)
      if value.is_a? Integer
        value
      else
        raise "not integer"
      end
    end

    def self.string!(value)
      if value.is_a? String
        value
      elsif value.is_a? Integer
        value.to_s
      else
        raise "not string"
      end
    end

    def self.tuple!(value)
      if value.is_a? Array
        value
      else
        raise "not tuple"
      end
    end
  end
end