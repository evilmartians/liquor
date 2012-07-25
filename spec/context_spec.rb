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
    expect { @context.declare 'a' }.not_to raise_error(Liquor::NameError)
    expect { @context.declare 'ext' }.not_to raise_error(Liquor::NameError)
  end

  it "mangles names" do
    @context.declare '_env'
    @context.access('_env').should_not be_nil
    @context.access('_env').should_not == '_env'
  end

  it "supports nesting" do
    @context.nest do
      @context.declare 'test'
    end
    expect { @context.access 'test' }.to raise_error(Liquor::NameError)
  end

  it "shadows variables" do
    @context.declare 'test'
    var_a = @context.access 'test'

    var_b = @context.nest do
      @context.declare 'test'
      @context.access 'test'
    end

    var_c = @context.access 'test'

    var_a.should_not == var_b
    var_a.should == var_c
  end
end