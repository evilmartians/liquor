require "spec_helper"

describe Liquor do
  it "supports {% assign var = value %}" do
    exec(%Q{
      {% assign test = 'hello world' %}
      {{ test }}
    }).strip.should == 'hello world'

    expect {
      exec(%Q{
        {% assign test = 1 %}
        {% assign test = 2 %}
      })
    }.to raise_error(Liquor::NameError, %r|is already occupied|)

    expect {
      exec(%Q{
        {% assign true = false %}
      })
    }.to raise_error(Liquor::NameError, %r|is already occupied by builtin|)
  end
end