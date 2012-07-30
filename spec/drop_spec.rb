require "spec_helper"

describe Liquor::Drop do
  it "should export attributes" do
    strukt = Struct.new(:a, :b)
    klass = Class.new(Liquor::Drop) do
      attributes :a, :b
    end

    datum = strukt.new(1, "hello")
    drop  = klass.new(datum)

    exec('{{ drop.a }} {{ drop.b }}', drop: drop).should == '1 hello'
    expect { exec('{{ drop.c }}') }.to raise_error
  end
end