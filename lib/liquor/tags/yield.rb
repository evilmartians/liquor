module Liquor

  # Within the context of a layout, yield identifies a section where content from the view should be inserted. 
  # The simplest way to use this is to have a single yield, into which the entire contents of the view currently 
  # being rendered is inserted.
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
  class Yield < Tag
    Syntax = /(#{VariableSignature}+){0,1}/   
  
    def initialize(tag_name, markup, tokens)          
      if markup =~ Syntax
        @what = $1
        @what = "_rendered_template_" if @what.blank?        
      else
        raise SyntaxError.new("Syntax Error in 'yield' - Valid syntax: yield [name]")
      end
      
      super      
    end
  
    def render(context)
      res = context["content_for"][@what]
      if res.present? && res.is_a?(Array)
        res = res.first
      elsif res.blank?
        res = ''
      end
       
      res
    end 
  
  end  
  
  Template.register_tag('yield', Yield)  
end