module Liquor
  module Droppable
    module ClassMethods
      def to_drop
        DropDelegation.wrap_scope(self)
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def to_drop
      DropDelegation.wrap_element(self)
    end
  end
end