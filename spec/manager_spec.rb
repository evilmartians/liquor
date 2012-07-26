require 'spec_helper'

describe Liquor::Manager do
  it "should be able to compile templates" do
    manager = Liquor::Manager.new
    expect {
      manager.compile_and_register! 'test', '{{ i }}', [:i]
    }.to_not raise_error
    manager.fetch('test').call(i: 10).should == '10'
  end
end