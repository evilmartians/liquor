module Liquor

  # The content_for method allows you to insert content into a yield block in your layout. 
  # You only use content_for to insert content in named yields. 
  # 
  # In your layout:
  #  <title>{% yield title %}</title>
  #  <body>{% yield %}</body>
  #
  # In the view:
  #  {% content_for title %} The title {% end_content_for %}
  #  The body    
  #
  #
  # Will produce:
  #  <title>The title</title>
  #  <body>The body</body>
  #
  #
  class ContentFor < Block
    SyntaxHelp = "Syntax Error in tag 'content_for' - Valid syntax: content_for [name]"
    Syntax = /(#{VariableSignature}+)/   
    
    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @name = $1
      else
        raise SyntaxError.new(SyntaxHelp)
      end

      super
    end
    
    def render(context)      
      result = ''
      
      context.stack do
        result = render_all(@nodelist, context).join
      end
            
      context['content_for'] = {} unless context.has_key? 'content_for'
      context['content_for'][@name] = result
      
      ''
    end
    
    def block_delimiter
      "end_#{block_name}"
    end
    
  end

  Template.register_tag('content_for', ContentFor)
end