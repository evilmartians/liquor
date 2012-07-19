require "spec_helper"

describe Liquor::Function do
  it "allows to define a function" do
    fun = Liquor::Function.new("test",
          unnamed_arg: true,
          mandatory_named_args: [:test, :next],
          optional_named_args:  [:once_more]) do |arg, kw|
      arg + kw[:add]
    end
    fun.unnamed_arg.should == true
    fun.optional_named_args.should == [:once_more]
    fun.call(1, add: 2).should == 3
  end

  it "requires a body" do
    expect {
      Liquor::Function.new("test")
    }.to raise_error
  end
end