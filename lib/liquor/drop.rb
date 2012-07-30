module Liquor
  class Drop
    include Liquor::External

    def initialize(source)
      @source = source
    end

    def self.attributes(*attrs)
      attrs.each do |attr|
        define_method(attr) {
          @source.send(attr)
        }
        export attr
      end
    end
  end
end