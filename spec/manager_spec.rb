require 'spec_helper'

describe Liquor::Manager do
  before do
    @manager = Liquor::Manager.new
  end

  it "should be able to compile templates" do
    @manager.register_template 'test', '{{ i }}', [:i]
    @manager.compile.should be_true

    @manager.render('test', i: 10).should == '10'
  end

  it "should decorate errors" do
    @manager.register_template 'test', '{{ }}', [:i]
    @manager.compile.should be_false

    @manager.errors.count.should == 1
    error = @manager.errors.first

    @manager.decorate(error).should == [
      "{{ }}",
      "   ^^"
    ]
  end

  it "should check names for correctness" do
    expect {
      @manager.register_template '_test', '{{ i }}', [:i]
    }.to raise_error ArgumentError, %r|is a partial|
    expect {
      @manager.register_partial 'test', '{{ i }}'
    }.to raise_error ArgumentError, %r|is not a partial|
  end

  it "should report presence of templates" do
    @manager.register_template 'test', '{{ i }}', [:i]
    @manager.compile.should be_true

    @manager.has_template?('test').should be_true
    @manager.has_template?('foo').should be_false
  end

  it "should render layouts" do
    @manager.register_layout 'layout', '{% yield "head" %} 1 {% yield %}'
    @manager.register_template 'action', '{% content_for "head" capture: %} 2 {% end content_for %} 3'
    @manager.compile.should be_true

    @manager.render_with_layout('layout', {}, 'action', {}).
          scan(/\d+/).should == %w(2 1 3)
  end

  it "exports libraries to compiler" do
    lib = Module.new do
      include Liquor::Library

      function "hello" do |arg, kw|
        "world"
      end
    end

    manager = Liquor::Manager.new(import: [lib])
    manager.register_template 'test', '{{ hello() }}'
    manager.compile.should be_true

    manager.render('test').should == 'world'
  end

  it "dumps debug code" do
    require 'tmpdir'

    Dir.mktmpdir do |code_dir|
      manager = Liquor::Manager.new(dump_intermediates: code_dir)
      manager.register_template 'test', '{{ "hello world" }}'
      manager.compile.should be_true

      path = File.join(code_dir, 'test.liquor.rb')

      File.exists?(path).should be_true
      File.read(path).include?('hello world').should be_true
    end
  end
end
