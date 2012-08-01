module Liquor
  class Drop::Scope
    include Liquor::External

    def initialize(source)
      @source = source
    end

    def first
      DropDelegation.wrap_element @source.first
    end

    def last
      DropDelegation.wrap_element @source.last
    end

    def [](index)
      DropDelegation.wrap_element @source[index]
    end

    def each
      @source.each do |elem|
        yield DropDelegation.wrap_element(elem)
      end
    end

    def count
      @source.count
    end

    export :first, :last, :[], :count
  end
end