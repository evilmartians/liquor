require 'active_record'

module Liquor
  class Drop
    include Liquor::External

    attr_reader :source

    def self.inherited(klass)
      klass.instance_exec do
        const_set :Scope, Class.new(::Liquor::Drop::Scope)
        const_get(:Scope).instance_exec do
          export # refresh liquor_exports
        end
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
            DropDelegation.wrap_scope @source.send(scope, *args)
          }
          export scope
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
          if value.nil?
            nil
          else
            DropDelegation.wrap_element(value)
          end
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

        DropDelegation.wrap_scope(value, value.klass)
      }

      export name
    end

    def model_name
      @source.class.model_name
    end
    export :model_name

    def ==(other)
      if other.is_a? Liquor::Drop
        self.source == other.source
      else
        other == self
      end
    end

    def to_drop
      self
    end
  end
end

require 'liquor/drop_delegation'
require 'liquor/drop_scope'
require 'liquor/dropable'