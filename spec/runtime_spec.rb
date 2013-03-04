require 'spec_helper'

describe Liquor::Runtime do
  def capture_diagnostics
    Liquor::Runtime.capture_diagnostics do
      yield
    end
  end

  def check_with_diagnostic(code, error_patterns, result)
    code, locals = *code
    actual_errors = Liquor::Runtime.capture_diagnostics do
      exec(code, locals || {}).should == result
    end

    actual_errors.count.should eq error_patterns.count
    error_patterns.zip(actual_errors).each do |(error_pattern, actual_error)|
      actual_error.message.should =~ error_pattern
    end
  end

  it "should report correct errors and substitutions for {{}}" do
    capture_diagnostics { Liquor::Runtime.interp!([], {}).should == "" }
    check_with_diagnostic('a{{ [] }}b', [ %r|String or Null value expected, Tuple found| ], 'ab')
  end

  it "should report correct errors and substitutions for a.b" do
    capture_diagnostics { Liquor::Runtime.external!(1, {}).should be_a Liquor::Runtime::DummyExternal }
    check_with_diagnostic('a{{ [].b.c }}b', [
      %r|External value expected, Tuple found|,
      %r|External value expected, Null found|,
    ], 'ab')
  end

  it "should report correct errors and substitutions for a[b]" do
    capture_diagnostics { Liquor::Runtime.tuple!(1, {}).should == [] }
    check_with_diagnostic('a{{ (1)[2] }}b', [
      %r|Tuple or indexable External value expected, Integer found|,
    ], 'ab')
  end

  it "should report correct errors and substitutions for +" do
    capture_diagnostics { Liquor::Runtime.integer!("", {}).should == 0 }
    capture_diagnostics { Liquor::Runtime.string!([], {}).should == "" }
    check_with_diagnostic('a{{ 1 + "" }}b', [
      %r|Integer value expected, String found|,
    ], 'a1b')
    check_with_diagnostic('a{{ "qq" + [] }}b', [
      %r|String value expected, Tuple found|,
    ], 'aqqb')
    check_with_diagnostic('a{{ join([1,"test"] + "asd") }}b', [
      %r|Tuple or indexable External value expected, String found|,
    ], 'a1 testb')
  end

  it "should report type errors for functions and continue" do
    check_with_diagnostic('a{{ join("a" with: "q") }}b', [
      %r|Tuple value expected, String found|
    ], 'ab')
    check_with_diagnostic('a{{ to_number(true) }}b', [
      %r|Integer, String value expected, Boolean found|
    ], 'a0b')
  end

  describe "with deprecations" do
    before do
      @klass = Class.new do
        include Liquor::External

        def foo
          1
        end
        export    :foo
        deprecate :foo, date: '2013-03-04', message: 'not available'
      end
    end

    it "does not treat deprecation as fatal" do
      exec('{{ bar.foo }}', bar: @klass.new).
        should == '1'
    end

    it "reports deprecations" do
      check_with_diagnostic([ '{{ bar.foo }}', { bar: @klass.new }], [
        %r|`foo' is deprecated and will be removed after 2013-03-04: not available|
      ], '1')
    end

    it "allows to make deprecations fatal" do
      expect {
        Liquor::Runtime.with_fatal_deprecations do
          exec '{{ bar.foo }}', bar: @klass.new
        end
      }.to raise_error(Liquor::Deprecation)
    end
  end
end
