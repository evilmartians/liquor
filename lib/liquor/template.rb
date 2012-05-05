module Liquor

  # Templates are central to liquor.
  # Interpretating templates is a two step process. First you compile the
  # source code you got. During compile time some extensive error checking is performed.
  # your code should expect to get some SyntaxErrors.
  #
  # After you have a compiled template you can then <tt>render</tt> it.
  # You can use a compiled template over and over again and keep it cached.
  #
  # Example:
  #
  #   template = Liquor::Template.parse(source)
  #   template.render('user_name' => 'bob')
  #
  class Template
    attr_accessor :root
    @@file_system = BlankFileSystem.new

    class << self
      def file_system
        @@file_system
      end

      def file_system=(obj)
        @@file_system = obj
      end

      def register_tag(name, klass)
        tags[name.to_s] = klass
      end

      def tags
        @tags ||= {}
      end

      # Pass a module with filter methods which should be available
      # to all liquor views. Good for registering the standard library
      def register_filter(mod)
        Strainer.global_filter(mod)
      end

      def get_filters
        Strainer.get_filters
      end

      # creates a new <tt>Template</tt> object from liquor source code
      def parse(source)
        template = Template.new
        template.parse(source)
        template
      end
    end

    # creates a new <tt>Template</tt> from an array of tokens. Use <tt>Template.parse</tt> instead
    def initialize
    end

    # Parse source code.
    # Returns self for easy chaining
    def parse(source)
      @root = Document.new(tokenize(source))
      self
    end

    def registers
      @registers ||= {}
    end

    def assigns
      @assigns ||= {}
    end

    def instance_assigns
      @instance_assigns ||= {}
    end

    def errors
      @errors ||= []
    end

    # Render takes a hash with local variables.
    #
    # if you use the same filters over and over again consider registering them globally
    # with <tt>Template.register_filter</tt>
    #
    # Following options can be passed:
    #
    #  * <tt>filters</tt> : array with local filters
    #  * <tt>registers</tt> : hash with register variables. Those can be accessed from
    #    filters and tags and might be useful to integrate liquor more with its host application
    #  * <tt>layout</tt>: Liquor::Template object which describes layout for this template
    #
    
    def render(*args)   
      return '' if @root.nil?       
      
      context = case args.first
      when Liquor::Context
        args.first
      when Hash
        Context.new([args.first, assigns], instance_assigns, registers, @rethrow_errors)
      when nil
        Context.new(assigns, instance_assigns, registers, @rethrow_errors)
      else
        raise ArgumentError, "Expect Hash or Liquor::Context as parameter"
      end
            
      options = nil
      case args.last
      when Hash
        options = args.last
        
        if options[:registers].is_a?(Hash)
          self.registers.merge!(options[:registers])  
        end

        if options[:filters]
          context.add_filters(options[:filters])
        end
        
        if options[:layout]
          raise ArgumentError, "Expected Liquor::Template as layout argument" unless options[:layout].is_a? Liquor::Template
        end                   
                
      when Module
        context.add_filters(args.last)    
      when Array
        context.add_filters(args.last)            
      end
                                                            
      begin 
        # render the nodelist.
        # for performance reasons we get a array back here. join will make a string out of it
        res = @root.render(context).join
                
        if options && options[:layout]
          content_for_assigns = (context.has_key?("content_for") ? context["content_for"] : {})
          content_for_assigns = content_for_assigns.merge({ "_rendered_template_" => res })
          
          case args.first
          when Liquor::Context
            args.first["content_for"] = content_for_assigns
          when Hash
            args.first.merge!({ "content_for" => content_for_assigns })
          end 
          
          layout_template = args.last.delete(:layout)
          
          # Here we execute render method of the Liquor::Template object (we execute _this_ method)
          # It is not the @root.render method. It is a result of the @root.render(context).join
          # so we don't need to call join here.
          res = layout_template.render(*args)
        end
        
        res
      ensure
        @errors = context.errors
      end
    end

    def render!(*args)
      @rethrow_errors = true; render(*args)
    end

    private

    # Uses the <tt>Liquor::TemplateParser</tt> regexp to tokenize the passed source
    def tokenize(source)
      source = source.source if source.respond_to?(:source)
      return [] if source.to_s.empty?
      tokens = source.split(TemplateParser)

      # removes the rogue empty element at the beginning of the array
      tokens.shift if tokens[0] and tokens[0].empty?

      tokens
    end

  end
end
