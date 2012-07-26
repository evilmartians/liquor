require "spec_helper"

describe Liquor::Partials do
  it "should be possible to use content_for and yield" do
    exec(%Q|
      {% yield test %}
      1
      {% content_for test capture: %}
        data
      {% end content_for %}
      2
      {% yield test %}
      {% yield test %}
    |).scan(/\w+/).should == %w(1 2 data data)
  end

  it "should be possible to use layouts" do
    manager = Liquor::Manager.new
    manager.compile_and_register! 'layout', '{% yield head %} 1 {{ yield }}', [:yield]
    manager.compile_and_register! 'action', '{% content_for head capture: %} 2 {% end content_for %} 3'

    storage = {}
    action_text = manager.fetch('action').call({}, storage)
    layout_text = manager.fetch('layout').call({ yield: action_text }, storage)
    layout_text.scan(/\d+/).should == %w(2 1 3)
  end

  it "should be possible to include partials" do
    manager = Liquor::Manager.new
    manager.compile_and_register! 'layout', '1 {% include "action" x: 2 %} 3'
    manager.compile_and_register! 'action', '{{ x }}', [ :x ]
    manager.fetch('layout').call.should == '1 2 3'
  end
end