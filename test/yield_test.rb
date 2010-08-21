require File.dirname(__FILE__) + '/helper'

class YieldTest < Test::Unit::TestCase
  include Liquor
  
  def test_yield_for_layout
    layout_template = '<title>test</title> <body>{% yield %}</body>'
    view_template = '{% assign text="body" %}{{ text }}'
    
    rendered_template = Template.parse(view_template).render({ :layout => Template.parse(layout_template) })
    
    assert_equal '<title>test</title> <body>body</body>', rendered_template
  end
  
  def test_yield_for_not_defined
    layout_template = '<title>{% yield title %}</title> <body>{% yield %}</body>'
    view_template = '{% assign text="body" %}{{ text }}'
    
    rendered_template = Template.parse(view_template).render({ :layout => Template.parse(layout_template) })
    
    assert_equal '<title></title> <body>body</body>', rendered_template
  end

end