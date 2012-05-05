module Liquor

  # A drop in liquor is a class which allows you to to export DOM like things to liquor
  # Methods of drops are callable.
  # The main use for liquor drops is the implement lazy loaded objects.
  # If you would like to make data available to the web designers which you don't want loaded unless needed then
  # a drop is a great way to do that
  #
  # Example:
  #
  # class ProductDrop < Liquor::Drop
  #   def top_sales
  #      Shop.current.products.find(:all, :order => 'sales', :limit => 10 )
  #   end
  # end
  #
  # tmpl = Liquor::Template.parse( ' {% for product in product.top_sales %} {{ product.name }} {%endfor%} '  )
  # tmpl.render('product' => ProductDrop.new ) # will invoke top_sales query.
  #
  # Your drop can either implement the methods sans any parameters or implement the before_method(name) method which is a
  # catch all
  class Drop
    attr_writer :context

    class_inheritable_reader :liquor_attributes
    write_inheritable_attribute :liquor_attributes, []

    class_inheritable_reader :liquor_scopes
    write_inheritable_attribute :liquor_scopes, []
    attr_reader :source

    class_inheritable_reader :has_manies
    write_inheritable_attribute :has_manies, []

    def logger
      Rails.logger
    end

    def self.allow_all_methods(allow = true)
      if allow
        class_eval <<-"END"
          def before_method(method)
            @source.send(method.to_sym)
          end

          def respond_to?(val)
            return true if @source.respond_to?(val.to_sym)
            return true if liquor_attributes.include? val.to_sym
            super
          end
        END
      end
    end
        
    def self.has_one(name)
      self.instance_eval do
        define_method(name) do
          (@source.send(name)).to_liquor
        end
      end  
    end

    def self.belongs_to(name)    
      self.instance_eval do
        define_method(name) do
          (@source.send(name)).to_liquor
        end
      end
    end
    
    def respond_to?(val)
      return true if liquor_attributes.include? val.to_sym
      super
    end

    def self.has_many(name, options={})
      options = options.reverse_merge({ :class_name => name.to_s.classify + "Drop", :sort_scope => :recent, :source_class_name => name.to_s.classify })

      klass = options[:class_name].constantize
      source_klass = options[:source_class_name].constantize

      self.instance_eval do
        has_manies << name

        define_method name do
          proxy = DropProxy.new(self, name, klass)
          proxy = proxy.send(options[:with_scope]) if options[:with_scope].present? && source_klass.respond_to?(options[:with_scope])
          proxy = proxy.send(options[:sort_scope]) if options[:sort_scope].present? && source_klass.respond_to?(options[:sort_scope])
          proxy
        end
      end
    end
    
    def initialize(source = nil)
      @source = source
      @liquor = liquor_attributes.inject({}) { |h, k| h.update k.to_s => @source.send(k) }
    end
    
    def drop_name
      self.class.name
    end

    def source_id
     @source.id
    end

    def has_scope?(meth)
      liquor_scopes.include?(meth.to_sym)
    end

    def has_many?(meth)
      has_manies.include?(meth.to_sym)
    end
    
    # Catch all for the method
    def before_method(method)
      @liquor[method.to_s]
    end

    def ==(comparison_object)
      our_self = self.source ? self.source : source
      our_self == (comparison_object.is_a?(self.class) ? comparison_object.source : comparison_object)
    end

    # called by liquor to invoke a drop
    def invoke_drop(method)
      # for backward compatibility with Ruby 1.8
      methods = self.class.public_instance_methods.map { |m| m.to_s }
      if methods.include?(method.to_s)
        send(method.to_sym)
      else
        before_method(method)
      end
    end

    def has_key?(name)
      true
    end

    def to_liquor
      self
    end
    
    def as_json(options = {})
      options = options.duplicable? ? options.dup : {}
      
      only = liquor_attributes

      if options[:include].present?
        klass_name = options[:include].to_s.singularize.classify + "Drop"
        only += klass_name.constantize.liquor_attributes
      end

      options = options.reverse_merge(:only => only)
      @source.as_json(options)
    end

    alias :[] :invoke_drop
        
    # converts an array of records to an array of liquor drops, and assigns the given context to each of them
    def self.liquify(current_context, *records, &block)
      i = -1
      records = 
        records.inject [] do |all, r|
          i+=1
          attrs = (block && block.arity == 1) ? [r] : [r, i]
          all << (block ? block.call(*attrs) : r.to_liquor)
          all.last.context = current_context if all.last.is_a?(Drop)
          all
        end
      records.compact!
      records
    end

    protected
       def liquify(*records, &block)
         self.class.liquify(@context, *records, &block)
       end
       
    class DropProxy
      attr_reader :current, :parent

      def initialize(parent, name, klass)
        @parent = parent
        @klass = klass

        if @parent.class == DropProxy
          @current = @parent.current
        elsif name.present?
          @current = @parent.source.send name
        end  
      end

      def liquify(*collection)
        @parent.send :liquify, *collection
      end

      def self.liquor_scopes
        @parent.class.liquor_scopes
      end

      #
      # It is very important that we do not delegate the 'to_liquor' method and it returns 'self'.
      NON_DELEGATE_METHODS = ['class', 'send', 'to_liquor', 'respond_to?']
      [].methods.each do |m|
        unless m =~ /^__/ || NON_DELEGATE_METHODS.include?(m.to_s)
          delegate m, :to => :proxy_found
        end
      end

      def to_liquor
        self
      end

      def proxy_found
        @collection ||= get_collection
        @parent.send :liquify, *@collection
      end

      def has_scope?(meth)
        @klass.liquor_scopes.include?(meth.to_sym)
      end

      private
        def method_missing(meth, *args)
          if has_scope?(meth)
            converted_args = args.collect{|arg| 
              if arg.is_a? DropProxy
                arg.current
              elsif arg.is_a?(Drop)
                arg.source
              else
                if arg.is_a?(Array)
                  arg = arg.collect{|x| x.source }
                end
                arg
              end
            }
            @current = @current.send(meth, *converted_args)
            DropProxy.new(self, meth, @klass)
          else
            super
          end
        end

        def get_collection
          @collection = @current
        end

         # HACK
        def set_current(val)
          @current = val
        end
    end
  end
end