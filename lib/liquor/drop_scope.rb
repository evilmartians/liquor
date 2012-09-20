module Liquor
  class Drop::Scope
    include Liquor::External

    attr_reader :source

    def initialize(source)
      @source = source
    end

    # Not exported
    def to_a
      @source.map do |elem|
        DropDelegation.wrap_element(elem)
      end
    end

    def find_by(_, fields={})
      result = @source.where(fields).first
      DropDelegation.wrap_element result
    end

    def find_all_by(_, fields={})
      result = @source.where(fields)
      DropDelegation.wrap_scope(result)
    end
    export :find_all_by, :find_by

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
    alias size count # for builtin compatibility

    export :first, :last, :[], :size, :count

    def limit(count)
      DropDelegation.wrap_scope @source.limit(count)
    end

    def offset(count)
      DropDelegation.wrap_scope @source.offset(count)
    end

    export :limit, :offset
  end
end
