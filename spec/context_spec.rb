require "spec_helper"

describe Liquor::Context do
  before do
    @compiler = Liquor::Compiler.new
    @context  = Liquor::Context.new(@compiler, ['ext', 'ext2'])
  end

  it "declares variables" do
    @context.type('a').should == :free
    @context.declare 'a'
    @context.type('a').should == :variable
  end

  it "verifies variable names" do
    expect { @context.declare 'null' }.to raise_error(Liquor::NameError)
    expect { @context.declare 'a' }.not_to raise_error
    expect { @context.declare 'a' }.to raise_error(Liquor::NameError)
    expect { @context.declare 'ext' }.to raise_error(Liquor::NameError)
  end

  it "mangles names" do
    @context.declare '_env'
    @context.access('_env').should_not == '_env'
  end

  it "supports nesting" do
    @context.nest do
      @context.declare 'test'
    end
    expect { @context.access 'test' }.to raise_error(Liquor::NameError)
  end
end