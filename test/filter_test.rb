#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/helper'

module MoneyFilter
  def money(input)
    sprintf(' %d$ ', input)
  end

  def money_with_underscore(input)
    sprintf(' %d$ ', input)
  end
end

module CanadianMoneyFilter
  def money(input)
    sprintf(' %d$ CAD ', input)
  end
end

module FiltersWithArguments
  def adjust(input, offset=10)
    sprintf('[%d]', input+offset)
  end
  
  def addsub(input, plus, minus=20)
    sprintf('[%d]', input+plus-minus)
  end
end

class FiltersTest < Test::Unit::TestCase
  include Liquor

  def setup
    @context = Context.new
  end

  #def test_nonexistent_filter
  #  @context['var'] = 1000
  #  assert_match /Error - filter 'money'/, Variable.new("var | money").render(@context)
  #end

  def test_nonexistent_filter
    @context['var'] = 1000
    # assert_raises(FilterNotFound) { Variable.new("var | xyzzy").render(@context) }
    assert_equal 1000, Variable.new("var | xyzzy").render(@context)
  end

  def test_local_filter
    @context['var'] = 1000
    @context.add_filters(MoneyFilter)
    assert_equal ' 1000$ ', Variable.new("var | money").render(@context)
  end

  def test_underscore_in_filter_name
    @context['var'] = 1000
    @context.add_filters(MoneyFilter)
    assert_equal ' 1000$ ', Variable.new("var | money_with_underscore").render(@context)
  end

  def test_filter_with_numeric_argument
    @context['var'] = 1000
    @context.add_filters(FiltersWithArguments)
    assert_equal '[1005]', Variable.new("var | adjust: 5").render(@context)
  end

  def test_filter_with_negative_argument
    @context['var'] = 1000
    @context.add_filters(FiltersWithArguments)
    assert_equal '[995]', Variable.new("var | adjust: -5").render(@context)
  end

  def test_filter_with_default_argument
    @context['var'] = 1000
    @context.add_filters(FiltersWithArguments)
    assert_equal '[1010]', Variable.new("var | adjust").render(@context)
  end

  def test_filter_with_two_arguments
    @context['var'] = 1000
    @context.add_filters(FiltersWithArguments)
    assert_equal '[1150]', Variable.new("var | addsub: 200, 50").render(@context)
  end

  # ATM the trailing value is silently ignored. Should raise an exception?
  #def test_filter_with_two_arguments_no_comma
  #  @context['var'] = 1000
  #  @context.add_filters(FiltersWithArguments)
  #  assert_equal '[1150]', Variable.new("var | addsub: 200 50").render(@context)
  #end

  def test_second_filter_overwrites_first
    @context['var'] = 1000
    @context.add_filters(MoneyFilter)
    @context.add_filters(CanadianMoneyFilter)
    assert_equal ' 1000$ CAD ', Variable.new("var | money").render(@context)
  end

  def test_size
    @context['var'] = 'abcd'
    @context.add_filters(MoneyFilter)
    assert_equal 4, Variable.new("var | size").render(@context)
  end

  def test_join
    @context['var'] = [1,2,3,4]
    assert_equal "1 2 3 4", Variable.new("var | join").render(@context)
  end

  def test_sort
    @context['value'] = 3
    @context['numbers'] = [2,1,4,3]
    @context['words'] = ['expected', 'as', 'alphabetic']
    @context['arrays'] = [['flattened'], ['are']]
    assert_equal [1,2,3,4], Variable.new("numbers | sort").render(@context)
    assert_equal ['alphabetic', 'as', 'expected'],
      Variable.new("words | sort").render(@context)
    assert_equal [3], Variable.new("value | sort").render(@context)
    assert_equal ['are', 'flattened'], Variable.new("arrays | sort").render(@context)
  end

  def test_strip_html
    @context['var'] = "<b>bla blub</a>"
    assert_equal "bla blub", Variable.new("var | strip_html").render(@context)
  end

  def test_capitalize
    @context['var'] = "blub"
    assert_equal "Blub", Variable.new("var | capitalize").render(@context)
  end
end

class FiltersInTemplate < Test::Unit::TestCase
  include Liquor

  def test_local_global
    Template.register_filter(MoneyFilter)

    assert_equal " 1000$ ", Template.parse("{{1000 | money}}").render(nil, nil)
    assert_equal " 1000$ CAD ", Template.parse("{{1000 | money}}").render(nil, :filters => CanadianMoneyFilter)
    assert_equal " 1000$ CAD ", Template.parse("{{1000 | money}}").render(nil, :filters => [CanadianMoneyFilter])
  end

  def test_local_filter_with_deprecated_syntax
    assert_equal " 1000$ CAD ", Template.parse("{{1000 | money}}").render(nil, CanadianMoneyFilter)
    assert_equal " 1000$ CAD ", Template.parse("{{1000 | money}}").render(nil, [CanadianMoneyFilter])
  end
end
