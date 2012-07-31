require 'active_record'

module Liquor
  module DropDelegationHelpers
    # aka module_method for every method.
    extend self

    def wrap_scope(scope)
      drop_klass = "#{scope.name}Drop::Scope".constantize
      drop_klass.new(scope)
    end

    def wrap_element(element)
      drop_klass = "#{element.class.name}Drop".constantize
      drop_klass.new(element)
    end
  end

  module Droppable
    module ClassMethods
      def to_drop
        DropDelegationHelpers.wrap_scope(self)
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def to_drop
      DropDelegationHelpers.wrap_element(self)
    end
  end

  class Drop
    include Liquor::External
    extend DropDelegationHelpers

    def self.inherited(klass)
      klass.instance_exec do
        const_set :Scope, Class.new(::Liquor::Drop::Scope)
      end
    end

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

    def self.scopes(*scopes)
      const_get(:Scope).instance_exec do
        scopes.each do |scope|
          define_method(scope) { |*args|
            @source.send(attr, *args)
          }
        end
      end
    end

    def self.define_singular_association_accessor(name, options={})
      if options.has_key?(:if) && options.has_key?(:unless)
        raise ArgumentError, "It is pointless to pass both :if and :unless conditions to has_one or belongs_to"
      end

      unsupported_options = (options.keys - [:if, :unless])
      if unsupported_options.any?
        raise ArgumentError, "Unsupported options #{unsupported_options.join(", ")}"
      end

      define_method(name) {
        value = @source.send(name)

        if self.class.check_singular_condition(value, options)
          wrap_element(value)
        end
      }

      export name
    end

    def self.check_singular_condition(object, options)
      execute = lambda do |object, condition|
        if condition.is_a? Symbol
          object.send(condition)
        elsif condition.respond_to? :call
          condition.(object)
        else
          raise ArgumentError, "Invalid condition type #{condition.class}"
        end
      end

      if options[:if]
        execute.(object, options[:if])
      elsif options[:unless]
        !execute.(object, options[:unless])
      else
        true
      end
    end

    def self.belongs_to(name, options={})
      define_singular_association_accessor(name, options)
    end

    def self.has_one(name, options={})
      define_singular_association_accessor(name, options)
    end

    def self.has_many(name, options={})
      unsupported_options = (options.keys - [:scope])
      if unsupported_options.any?
        raise ArgumentError, "Unsupported options #{unsupported_options.join(", ")}"
      end

      define_method(name) {
        value = @source.send(name)

        if options[:scope]
          # Sequentally apply each symbol from options[:scope]
          # to the current scope, starting from `value' and using
          # each result as current scope for the next operation.
          value = options[:scope].to_ary.reduce(value, &:send)
        end

        value
      }

      export name
    end
  end

  class Drop::Scope
    include Liquor::External
    extend DropDelegationHelpers

    def initialize(source)
      @source = source
    end

    def first
      self.class.wrap_element @source.first
    end

    def last
      self.class.wrap_element @source.last
    end

    def [](index)
      self.class.wrap_element @source[index]
    end

    def count
      @source.count
    end

    export :first, :last, :[], :count
  end
end