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

  it "can compile interpolations" do
    exec('Test: {{ "str" }}').should == 'Test: str'
  end

  it "correctly executes expressions" do
    exec('{{ 1 + 2 * 5 + 2 }}').should == '13'
    exec('{{ -6 - -6 }}').should == '0'
    exec('{{ ([1,2,3])[1] }}').should == '2'
  end
end