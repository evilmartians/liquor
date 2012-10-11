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

  it "should check names for correctness" do
    expect {
      @manager.register_template '_test', '{{ i }}', [:i]
    }.to raise_error ArgumentError, %r|is a partial|
    expect {
      @manager.register_partial 'test', '{{ i }}'
    }.to raise_error ArgumentError, %r|is not a partial|
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

  it "accepts debug option" do
    manager = Liquor::Manager.new(debug: true)
    manager.should be_debug

    @manager.should_not be_debug
  end
end
