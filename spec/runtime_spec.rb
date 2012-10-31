require 'spec_helper'

describe Liquor::Runtime do
  def capture_errors
    Liquor::Runtime.capture_errors do
      yield
    end
  end

  def check_with_error(code, error_patterns, result)
    actual_errors = Liquor::Runtime.capture_errors do
      exec(code).should == result
    end

    actual_errors.count.should eq error_patterns.count
    error_patterns.zip(actual_errors).each do |(error_pattern, actual_error)|
      actual_error.message.should =~ error_pattern
    end
  end

  it "should report correct errors and substitutions for {{}}" do
    capture_errors { Liquor::Runtime.interp!([], {}).should == "" }
    check_with_error('a{{ [] }}b', [ %r|String or Null value expected, Tuple found| ], 'ab')
  end

  it "should report correct errors and substitutions for a.b" do
    capture_errors { Liquor::Runtime.external!(1, {}).should be_a Liquor::Runtime::DummyExternal }
    check_with_error('a{{ [].b.c }}b', [
      %r|External value expected, Tuple found|,
      %r|External value expected, Null found|,
    ], 'ab')
  end

  it "should report correct errors and substitutions for a[b]" do
    capture_errors { Liquor::Runtime.tuple!(1, {}).should == [] }
    check_with_error('a{{ (1)[2] }}b', [
      %r|Tuple or indexable External value expected, Integer found|,
    ], 'ab')
  end

  it "should report correct errors and substitutions for +" do
    capture_errors { Liquor::Runtime.integer!("", {}).should == 0 }
    capture_errors { Liquor::Runtime.string!([], {}).should == "" }
    check_with_error('a{{ 1 + "" }}b', [
      %r|Integer value expected, String found|,
    ], 'a1b')
    check_with_error('a{{ "qq" + [] }}b', [
      %r|String value expected, Tuple found|,
    ], 'aqqb')
    check_with_error('a{{ join([1,"test"] + "asd") }}b', [
      %r|Tuple or indexable External value expected, String found|,
    ], 'a1 testb')
  end
end