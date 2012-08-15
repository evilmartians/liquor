require "spec_helper"

describe Liquor do
  it "supports {% assign %} and {% declare %}" do
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
        {% declare test = 1 %}
        {% declare test = 2 %}
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

  it "shadows variables of {% for %}" do
    exec(%Q{
      {% assign var = 1 %}
      {% for var from: 1 to: 5 do: %}
      {% end for %}
      {{ var }}
    }).strip.should == '1'
  end

  it "does not shadow assignments within scopes" do
    exec(%Q{
      {% assign var = 1 %}
      {% for i from: 1 to: 5 do: %}
        {% assign var = i %}
      {% end for %}
      {{ var }}
    }).strip.should == '5'
  end

  it "maintains forloop special" do
    exec(%Q|
      {% for x in: ["a", "b", "c"] do: %}
        {{ forloop.length }}
        {{ forloop.index }}
        {{ forloop.rindex }}
        {% if forloop.is_first then: %}first{% end if %}
        {% if forloop.is_last then: %}last{% end if %}
        I
      {% end for %}
    |).scan(/\w+/).should == \
        %w(3 0 2 first I 3 1 1 I 3 2 0 last I)
  end

  it "correctly shadows forloop special" do
    exec(%Q|
      {% for x in: ["a", "b"] do: %}
        {{ x }} {{ forloop.index }}
        {% for y in: ["x", "y", "z"] do: %}
          {{ y }} {{ forloop.index }}
        {% end for %}
        {{ forloop.length }}
      {% end for %}
    |).scan(/\w+/).should == \
        %w(a 0 x 0 y 1 z 2 2 b 1 x 0 y 1 z 2 2)
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
      {% declare data = 1 %}
      {% capture test = %}
        {% declare data = 2 %}
        {{ data }}
      {% end capture %}
      {{ data }}
      {{ test }}
    }).scan(/\d+/).should == %w(1 2)
  end

  it "supports builtin functions" do
    exec(%!{{ "test" | size }}!).should == '4'
    exec(%!{{ [1, 2] | size }}!).should == '2'
    exec(%!{{ "abc" | upcase }}!).should == 'ABC'
    exec(%!{{ "Abc" | downcase }}!).should == 'abc'
    exec(%!{{ "abc def" | capitalize }}!).should == 'Abc def'
    exec(%!{{ "'" | url_escape }}!).should == '%27'
    exec(%!{% capture test = %}\na\nb{% end capture %}{{ test | strip_newlines }}!).should == 'ab'
    exec(%!{{ [ 1, 2, "a" ] | join }}!).should == '1 2 a'
    exec(%!{{ "abc abc" | replace pattern: 'abc' replacement: 'def' }}!).should == 'def def'
    exec(%!{{ "abc abc" | replace_first pattern: 'abc' replacement: 'def' }}!).should == 'def abc'
    exec(%!{{ "abc abc" | remove pattern: 'abc' }}!).should == ' '
    exec(%!{{ "abc abc" | remove_first pattern: 'abc' }}!).should == ' abc'
    exec(%!{% capture test = %}a\nb{% end capture %}{{ test | newline_to_br }}!).should == "a<br>\nb"
    exec(%!{{ '12 Jun' | strftime format: '%d' }}!).should == "12"
    exec(%!{{ to_number("12") + 10 }}!).should == "22"
    exec(%!{% if include([ 1, 2, 3 ] element: 2) then: %}yes{% end if %}!).should == "yes"
    exec(%!{{ [ 1, 2, 3 ] | reverse | join }}!).should == "3 2 1"
    exec(%!{{ [ 1, null, 3 ] | compact | join }}!).should == "1 3"
    exec(%!{% if even(1) then: %}yes{% else: %}no{% end if %}!).should == "no"
    exec(%!{% if odd(1) then: %}yes{% else: %}no{% end if %}!).should == "yes"
  end
end