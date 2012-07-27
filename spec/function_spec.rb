require "spec_helper"

describe Liquor::Function do
  it "allows to define a function" do
    fun = Liquor::Function.new("test",
          unnamed_arg: :integer,
          mandatory_named_args: { test: :any, add: :integer },
          optional_named_args:  { once_more: :any }) do |arg, kw|
      arg + kw[:add]
    end
    fun.unnamed_arg.should == :integer
    fun.optional_named_args.should == { once_more: :any }
    fun.call(1, add: 2).should == 3
  end

  it "requires a body" do
    expect {
      Liquor::Function.new("test")
    }.to raise_error
  end

  it "checks types" do
    fun = Liquor::Function.new("test",
          unnamed_arg: [:string, :tuple],
          optional_named_args: { some: :integer, other: :any }) do |arg, kw|
      # nothing
    end

    expect { fun.call("a") }.not_to raise_error
    expect { fun.call([1]) }.not_to raise_error
    expect { fun.call(1)   }.to raise_error(Liquor::ArgumentTypeError)
    expect { fun.call("a", some: "A") }.to raise_error(Liquor::ArgumentTypeError)
    expect { fun.call("a", other: 1)  }.not_to raise_error
    expect { fun.call("a", other: Class) }.to raise_error(Liquor::ArgumentTypeError)
  end
end