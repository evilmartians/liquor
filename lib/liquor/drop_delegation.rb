module Liquor
  module DropDelegation
    # aka module_method for every method.
    extend self

    def wrap_scope(scope, klass=scope)
      drop_klass = "#{klass.name}Drop::Scope".constantize
      drop_klass.new(scope)
    end

    def wrap_element(element)
      drop_klass = "#{element.class.name}Drop".constantize
      drop_klass.new(element)
    end

    def unwrap_drop_class(klass)
      drop_klass_name  = klass.name
      model_class_name = drop_klass_name.sub(/Drop$/, '')
      model_class_name.constantize
    end
  end
end