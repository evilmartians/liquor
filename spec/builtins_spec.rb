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
        {{ test }}
      }).should == '2'
    }.to_not raise_error(Liquor::NameError, %r|is already occupied|)

    expect {
      exec(%Q{
        {% assign true = false %}
      })
    }.to raise_error(Liquor::NameError, %r|is already occupied by builtin|)
  end

  it "supports {% if %}" do
    code = compile(%Q{
      {% if x == 1 then: %}
        one
      {% elsif: x > 1 && x < 10 then: %}
        few
      {% elsif: x > 10 then: %}
        many
      {% else: %}
        wat
      {% end if %}
    }, [:x])
    code.call(x: 1).strip.should == 'one'
    code.call(x: 5).strip.should == 'few'
    code.call(x: 11).strip.should == 'many'
    code.call(x: -1).strip.should == 'wat'
  end

  it "supports {% unless %}" do
    exec(%Q{
      {% unless 1 == 2 then: %}
        yes
      {% end unless %}
    }).strip.should == 'yes'

    exec(%Q{
      {% unless 1 == 1 then: %}
        yes
      {% end unless %}
      no
    }).strip.should == 'no'
  end

  it "supports {% for %}" do
    exec(%Q{
      {% for var in: [1, 2, 3] do: %}
        {{ var }}
      {% end for %}
    }).scan(/\d+/).should == %w(1 2 3)

    exec(%Q{
      {% for var from: 1 to: 5 do: %}
        {{ var }}
      {% end for %}
    }).scan(/\d+/).should == %w(1 2 3 4 5)
  end

  it "shadows variables within {% for %}" do
    exec(%Q{
      {% assign var = 1 %}
      {% for var from: 1 to: 5 do: %}
      {% end for %}
      {{ var }}
    }).strip.should == '1'
  end

  it "supports {% capture %}" do
    exec(%Q{
      {% capture data = %}
        {% for var from: 1 to: 3 do: %}{{ var + 1 }}{% end for %}
      {% end capture %}
      {{ data }}
      {{ data }}
    }).scan(/\d+/).should == %w'234 234'
  end

  it "reassigns variables within {% capture %}" do
    exec(%Q{
      {% assign data = 1 %}
      {% capture data = %}2{% end capture %}
      {{ data }}
    }).strip.should == '2'
  end

  it "shadows variables within {% capture %}" do
    exec(%Q{
      {% assign data = 1 %}
      {% capture test = %}
        {% assign data = 2 %}
        {{ data }}
      {% end capture %}
      {{ data }}
      {{ test }}
    }).scan(/\d+/).should == %w(1 2)
  end
end