require File.dirname(__FILE__) + '/helper'

class ContentForTest < Test::Unit::TestCase
  include Liquor
  
  def test_content_for
    layout_template = '<title>{% yield title %}</title> <body>{% yield %}</body>'
    view_template = '{% content_for title %}{% assign text="aaa" %}{{ text }}{% end_content_for %}{% assign text="body" %}{{ text }}'
    
    rendered_template = Template.parse(view_template).render({ :layout => Template.parse(layout_template) })
    
    assert_equal '<title>aaa</title> <body>body</body>', rendered_template
  end

end