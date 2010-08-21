#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/helper'

class TestClassA
  liquor_methods :allowedA, :chainedB
  def allowedA
    'allowedA'
  end
  def restrictedA
    'restrictedA'
  end
  def chainedB
    TestClassB.new
  end
end

class TestClassB
  liquor_methods :allowedB, :chainedC
  def allowedB
    'allowedB'
  end
  def chainedC
    TestClassC.new
  end
end

class TestClassC
  liquor_methods :allowedC
  def allowedC
    'allowedC'
  end
end

class TestClassC::LiquorDropClass
  def another_allowedC
    'another_allowedC'
  end
end

class ModuleExTest < Test::Unit::TestCase
  include Liquor
  
  def setup
    @a = TestClassA.new
    @b = TestClassB.new
    @c = TestClassC.new
  end
  
  def test_should_create_LiquorDropClass
    assert TestClassA::LiquorDropClass
    assert TestClassB::LiquorDropClass
    assert TestClassC::LiquorDropClass
  end
  
  def test_should_respond_to_liquor
    assert @a.respond_to?(:to_liquor)
    assert @b.respond_to?(:to_liquor)
    assert @c.respond_to?(:to_liquor)
  end
  
  def test_should_return_LiquorDropClass_object
    assert @a.to_liquor.is_a?(TestClassA::LiquorDropClass)
    assert @b.to_liquor.is_a?(TestClassB::LiquorDropClass)
    assert @c.to_liquor.is_a?(TestClassC::LiquorDropClass)
  end
  
  def test_should_respond_to_liquor_methods
    assert @a.to_liquor.respond_to?(:allowedA)
    assert @a.to_liquor.respond_to?(:chainedB)
    assert @b.to_liquor.respond_to?(:allowedB)
    assert @b.to_liquor.respond_to?(:chainedC)
    assert @c.to_liquor.respond_to?(:allowedC)
    assert @c.to_liquor.respond_to?(:another_allowedC)
  end

  def test_should_not_respond_to_restricted_methods
    assert ! @a.to_liquor.respond_to?(:restricted)
  end

  def test_should_use_regular_objects_as_drops
    assert_equal 'allowedA', Liquor::Template.parse("{{ a.allowedA }}").render('a'=>@a)
    assert_equal 'allowedB', Liquor::Template.parse("{{ a.chainedB.allowedB }}").render('a'=>@a)
    assert_equal 'allowedC', Liquor::Template.parse("{{ a.chainedB.chainedC.allowedC }}").render('a'=>@a)
    assert_equal 'another_allowedC', Liquor::Template.parse("{{ a.chainedB.chainedC.another_allowedC }}").render('a'=>@a)
    assert_equal '', Liquor::Template.parse("{{ a.restricted }}").render('a'=>@a)
    assert_equal '', Liquor::Template.parse("{{ a.unknown }}").render('a'=>@a)
 end

end