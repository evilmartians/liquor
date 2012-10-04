module Liquor
  class Drop::Scope
    include Liquor::External

    attr_reader :source

    def initialize(source)
      unless source.respond_to? :each
        source = source.scoped
      end

      @source = source
    end

    # Not exported.
    def to_a
      @source.map do |elem|
        DropDelegation.wrap_element(elem)
      end
    end

    def entity
      @source.model_name
    end
    export :entity

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

    # Not exported. No block support in Liquor.
    def each
      @source.each do |elem|
        yield DropDelegation.wrap_element(elem)
      end
    end

    def pluck(attribute)
      @source.map do |elem|
        DropDelegation.wrap_element(elem).liquor_send(attribute.to_s, [])
      end
    end

    def count
      @source.count
    end
    alias size count # for builtin compatibility

    export :first, :last, :[], :pluck, :size, :count

    def limit(count)
      DropDelegation.wrap_scope @source.limit(count)
    end

    def offset(count)
      DropDelegation.wrap_scope @source.offset(count)
    end

    def reverse
      DropDelegation.wrap_scope @source.reverse_order
    end

    export :limit, :offset, :reverse
  end
end
