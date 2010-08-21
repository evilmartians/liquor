require File.dirname(__FILE__) + '/helper'

class VariableTest < Test::Unit::TestCase
  include Liquor

  def test_blankspace
    template = Liquor::Template.parse("  ")
    assert_equal ["  "], template.root.nodelist
  end

  def test_variable_beginning
    template = Liquor::Template.parse("{{funk}}  ")
    assert_equal 2, template.root.nodelist.size
    assert_equal Variable, template.root.nodelist[0].class
    assert_equal String, template.root.nodelist[1].class
  end

  def test_variable_end
    template = Liquor::Template.parse("  {{funk}}")
    assert_equal 2, template.root.nodelist.size
    assert_equal String, template.root.nodelist[0].class
    assert_equal Variable, template.root.nodelist[1].class
  end

  def test_variable_middle
    template = Liquor::Template.parse("  {{funk}}  ")
    assert_equal 3, template.root.nodelist.size
    assert_equal String, template.root.nodelist[0].class
    assert_equal Variable, template.root.nodelist[1].class
    assert_equal String, template.root.nodelist[2].class
  end

  def test_variable_many_embedded_fragments
    template = Liquor::Template.parse("  {{funk}} {{so}} {{brother}} ")
    assert_equal 7, template.root.nodelist.size
    assert_equal [String, Variable, String, Variable, String, Variable, String], block_types(template.root.nodelist)
  end
  
  def test_with_block
    template = Liquor::Template.parse("  {% comment %} {% endcomment %} ")
    assert_equal [String, Comment, String], block_types(template.root.nodelist)    
    assert_equal 3, template.root.nodelist.size
  end
  
  def test_with_custom_tag 
    Liquor::Template.register_tag("testtag", Block) 
     
    assert_nothing_thrown do 
      template = Liquor::Template.parse( "{% testtag %} {% endtesttag %}") 
    end 
  end
  
  private
  
  def block_types(nodelist)
    nodelist.collect { |node| node.class }
  end
end