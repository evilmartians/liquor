require 'spec_helper'

describe Liquor::Compiler do
  it "correctly handles error workflow" do
    compiler = Liquor::Compiler.new
    compiler.errors.should be_empty

    compiler.compile '{{ $ }}'
    compiler.errors.should be_any
    compiler.code.should be_nil
    compiler.parse_tree.should be_nil

    compiler.compile '{{ a(t: 1 t: 1) }}'
    compiler.errors.should be_any
    compiler.code.should be_nil
    compiler.parse_tree.should_not be_nil

    compiler.compile '{{ "1" }}'
    compiler.errors.should be_empty
    compiler.code.should respond_to(:call)
    compiler.parse_tree.should_not be_nil
  end

  it "can compile plaintext" do
    exec('Hello World!').should == 'Hello World!'
  end
end