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

  it "handles unbound identifiers" do
    expect { compile('{{ i }}') }.to raise_error(Liquor::NameError, %r|is not bound|)
  end

  it "handles externals" do
    compiler = Liquor::Compiler.new
    compiler.compile '{{ i }}', [:i]
    compiler.code.call(i: 10).should == '10'
  end

  it "verifies function arguments" do
    compiler = Liquor::Compiler.new(import_builtins: false)

    a = Liquor::Function.new("substr",
          unnamed_arg: :string,
          optional_named_args: { from: :integer, to: :integer }) do |arg, kw|
      from, to = kw[:from] || 0, kw[:to] || -1
      arg[from..to]
    end
    compiler.register_function a

    b = Liquor::Function.new("yield",
          mandatory_named_args: { buffer: :string },
          optional_named_args:  { strip: :boolean }) do |arg, kw|
      # nothing
    end
    compiler.register_function b

    compiler.compile! '{{ substr("hello world") }}'
    compiler.code.call.should == 'hello world'

    compiler.compile! '{{ substr("hello world" from: 6) }}'
    compiler.code.call.should == 'world'

    compiler.compile! '{{ substr("hello world" to: 4) }}'
    compiler.code.call.should == 'hello'

    compiler.compile! '{{ substr("hello world" from: 1 to: 3) }}'
    compiler.code.call.should == 'ell'

    expect {
      compiler.compile! '{{ substr() }}'
    }.to raise_error(Liquor::ArgumentError, %r|unnamed argument is required|)

    expect {
      compiler.compile! '{{ substr("a" test: 1) }}'
    }.to raise_error(Liquor::ArgumentError, %r|named argument `test' is not accepted|)

    expect {
      compiler.compile! '{{ yield() }}'
    }.to raise_error(Liquor::ArgumentError, %r|named argument `buffer' is required|)

    expect {
      compiler.compile! '{{ yield("a" buffer: "test") }}'
    }.to raise_error(Liquor::ArgumentError, %r|unnamed argument is not accepted|)
  end

  it "works with filter expressions" do
    compiler = Liquor::Compiler.new(import_builtins: false)

    a = Liquor::Function.new("capitalize",
          unnamed_arg: :string) do |arg, kw|
      arg.capitalize
    end
    compiler.register_function a

    b = Liquor::Function.new("reverse",
          unnamed_arg: :string) do |arg, kw|
      arg.reverse
    end
    compiler.register_function b

    c = Liquor::Function.new("trim",
          unnamed_arg: :string,
          mandatory_named_args: { length: :integer }) do |arg, kw|
      arg[0...kw[:length]]
    end
    compiler.register_function c

    compiler.compile! '{{ "hello world" | reverse | trim length: 3 | capitalize }}'
    compiler.code.call.should == 'Dlr'
  end

  it "allows to define simple tags" do
    compiler = Liquor::Compiler.new(import_builtins: false)

    a = Liquor::Tag.new("test") do |emit, context, args|
      emit.cat! %{"hello world"}
    end
    compiler.register_tag a

    compiler.compile! '{% test %}'
    compiler.code.call.should == 'hello world'
  end

  it "allows to write tag continuations without colons" do
    compiler = Liquor::Compiler.new
    compiler.compile! '{% if a then: %} 1 {% elsif !a then: %} 2 {% end if %}', [:a]
    compiler.code.call(a: false).strip.should == '2'
  end
end