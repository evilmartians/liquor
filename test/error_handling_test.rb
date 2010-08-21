
#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/helper'

class ErrorDrop < Liquor::Drop
  def standard_error
    raise Liquor::StandardError, 'standard error'
  end  

  def argument_error
    raise Liquor::ArgumentError, 'argument error'
  end  
  
  def syntax_error
    raise Liquor::SyntaxError, 'syntax error'
  end  
  
end


class ErrorHandlingTest < Test::Unit::TestCase
  include Liquor
  
  def test_standard_error
    assert_nothing_raised do 
      template = Liquor::Template.parse( ' {{ errors.standard_error }} '  )
      assert_equal ' Liquor error: standard error ', template.render('errors' => ErrorDrop.new)
      
      assert_equal 1, template.errors.size
      assert_equal StandardError, template.errors.first.class
    end
  end
  
  def test_syntax    

    assert_nothing_raised do 
    
      template = Liquor::Template.parse( ' {{ errors.syntax_error }} '  )
      assert_equal ' Liquor syntax error: syntax error ', template.render('errors' => ErrorDrop.new)
      
      assert_equal 1, template.errors.size
      assert_equal SyntaxError, template.errors.first.class
      
    end
    
  end
  
  def test_argument

    assert_nothing_raised do 
    
      template = Liquor::Template.parse( ' {{ errors.argument_error }} '  )
      assert_equal ' Liquor error: argument error ', template.render('errors' => ErrorDrop.new)
      
      assert_equal 1, template.errors.size
      assert_equal ArgumentError, template.errors.first.class
      
    end
    
  end            
  
  def test_missing_endtag_parse_time_error
    
    assert_raise(Liquor::SyntaxError) do
      
      template = Liquor::Template.parse(' {% for a in b %} ... ')
      
    end
    
  end
  
  
  def test_unrecognized_operator
    
    assert_nothing_raised do
      
      template = Liquor::Template.parse(' {% if 1 =! 2 %}ok{% endif %} ')
      assert_equal ' Liquor error: Unknown operator =! ', template.render
      
      assert_equal 1, template.errors.size
      assert_equal Liquor::ArgumentError, template.errors.first.class
      
    end
    
  end
  
end


