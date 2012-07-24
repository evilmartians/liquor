#coding:utf-8

require 'spec_helper'

describe Liquor::Parser do
  it "parses plaintext" do
    parse("abc\ndef").should have_node_structure(
      [:plaintext, "abc\ndef"]
    )
  end

  it "recognizes interpolations" do
    parse("a {{ 1 + a }} b").should have_node_structure(
      [:plaintext, "a "],
      [:interp,
        [:plus,
          [:integer, 1],
          [:ident, "a"]]],
      [:plaintext, " b"],
    )
  end

  it "fails on incorrect syntax" do
    expect { parse("{{ }}") }.to raise_error(Liquor::SyntaxError, %r|unexpected token `}}'|)
    expect { parse("{{ 1 %}") }.to raise_error(Liquor::SyntaxError, %r|unexpected token `%}'|)
    expect { parse("{{ 1[2] }}") }.to raise_error(Liquor::SyntaxError, %r|unexpected token `\['|)
    expect { parse("{{ a[2 }}") }.to raise_error(Liquor::SyntaxError, %r|unexpected token `}}'|)
    expect { parse("{{ a && (b || ) }}") }.to raise_error(Liquor::SyntaxError, %r|unexpected token `\)'|)
  end

  it "obeys operator precedence" do
    parse('{{ 1 + 2 * 3 }}').should have_node_structure(
      [:interp,
        [:plus,
          [:integer, 1],
          [:mul,
            [:integer, 2],
            [:integer, 3]]]]
    )
    parse('{{ a && b || c && d }}').should have_node_structure(
      [:interp,
        [:or,
          [:and, [:ident, "a"], [:ident, "b"]],
          [:and, [:ident, "c"], [:ident, "d"]]]]
    )
    parse('{{ a || b && c || d }}').should have_node_structure(
      [:interp,
        [:or,
          [:or,
            [:ident, "a"],
            [:and, [:ident, "b"], [:ident, "c"]]],
          [:ident, "d"]]]
    )
  end

  it "changes evaluation order due to parentheses" do
    parse('{{ a && (b || c) }}').should have_node_structure(
      [:interp,
        [:and,
          [:ident, "a"],
          [:or, [:ident, "b"], [:ident, "c"]]]]
    )
  end

  it "recognizes every operator" do
    expect { parse('{{ fun(a: 1 + 2 * 3 / 4 % 5 - 6 ' +
        ' b: !(a && b || c) c: (1 >= 2) || 1 < 2 || ' +
        'a != b || b == c || 5 <= 6 || 7 > 8 ' +
        'd: e.f e: ([1,2])[0] ) }}') }.not_to raise_error

    parse('{{ 2 - -1 }}').should have_node_structure(
      [:interp,
        [:minus,
          [:integer, 2],
          [:uminus, [:integer, 1]]]]
    )
    parse('{{ -1 }}').should have_node_structure(
      [:interp,
        [:uminus, [:integer, 1]]]
    )
  end

  it "accepts correct tuples" do
    parse('{{ [] }}').should have_node_structure(
      [:interp,
        [:tuple, []]]
    )
    parse('{{ [1] }}').should have_node_structure(
      [:interp,
        [:tuple, [ [:integer, 1] ]]]
    )
    parse('{{ [1,] }}').should have_node_structure(
      [:interp,
        [:tuple, [ [:integer, 1] ]]]
    )
    parse('{{ [1,2] }}').should have_node_structure(
      [:interp,
        [:tuple, [ [:integer, 1], [:integer, 2] ]]]
    )
    parse('{{ [1,2,] }}').should have_node_structure(
      [:interp,
        [:tuple, [ [:integer, 1], [:integer, 2] ]]]
    )
  end

  it "accepts correct method calls" do
    parse('{{ a() }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "a"],
          [:args, nil, {}]]]
    )
    parse('{{ a("str") }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "a"],
          [:args, [:string, "str"], {}]]]
    )
    parse('{{ a("str" from: 1) }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "a"],
          [:args, [:string, "str"],
                  {:from => [:integer, 1]}]]]
    )
    parse('{{ a(from: 1 to: 2) }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "a"],
          [:args, nil,
                  {:from => [:integer, 1],
                   :to   => [:integer, 2]}]]]
    )
  end

  it "rejects method calls with duplicate keyword arguments" do
    expect { parse('{{ a(to: 1 to: 1) }}') }.to \
                raise_error(Liquor::SyntaxError, %r|duplicate keyword argument `to'|)
  end

  it "accepts correct filter expressions" do
    parse('{{ a | b }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "b"],
          [:args,
            [:ident, "a"],
            {}]]]
    )
    parse('{{ a(x: 1) | b y: 2 z: 3 | c p: 4 }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "c"],
          [:args,
            [:call,
              [:ident, "b"],
              [:args,
                [:call,
                  [:ident, "a"],
                  [:args,
                    nil,
                    { :x => [:integer, 1] }]],
                { :y => [:integer, 2],
                  :z => [:integer, 3] }]],
            { :p => [:integer, 4] }]]]
    )
  end

  it "rejects malformed filter expressions" do
    expect { parse('{{ a b: 1 }}') }.to raise_error(Liquor::SyntaxError)
    expect { parse('{{ a("str", b: 1) | b ') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `|'})
    expect { parse('{{ a | b(b: 1)') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `\('})
    expect { parse('{{ a | b("str", b: 1)') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `\('})
  end

  it "parses blocks correctly" do
    parse('{% yield %}').should have_node_structure(
      [:tag,
        [:ident, "yield"],
        nil]
    )
    parse('{% yield 1 %}').should have_node_structure(
      [:tag,
        [:ident, "yield"],
        [:integer, 1]]
    )
    parse('{% yield from: 1 %}').should have_node_structure(
      [:tag,
        [:ident, "yield"],
        nil,
        [:kwarg, [:keyword, "from"], [:integer, 1]]]
    )
    parse('{% yield "str" from: 1 %}').should have_node_structure(
      [:tag,
        [:ident, "yield"],
        [:string, "str"],
        [:kwarg, [:keyword, "from"], [:integer, 1]]]
    )
    parse('{% yield from: 1 to: 2 from: 3 %}').should have_node_structure(
      [:tag,
        [:ident, "yield"],
        nil,
        [:kwarg, [:keyword, "from" ], [:integer, 1]],
        [:kwarg, [:keyword, "to" ],   [:integer, 2]],
        [:kwarg, [:keyword, "from" ], [:integer, 3]]]
    )
    parse('{% capture do: %} 1 {% end capture %}').
              should have_node_structure(
      [:tag,
        [:ident, "capture"],
        nil,
        [:blockarg, [:keyword, "do"],
          [
            [:plaintext, " 1 "]
          ]]]
    )
    parse('{% capture "test" do: %} 1 {% end capture %}').
              should have_node_structure(
      [:tag,
        [:ident, "capture"],
        [:string, "test"],
        [:blockarg, [:keyword, "do"],
          [
            [:plaintext, " 1 "]
          ]]]
    )
    parse('{% capture as: "test" do: %} 1 {% end capture %}').
              should have_node_structure(
      [:tag,
        [:ident, "capture"],
        nil,
        [:kwarg, [:keyword, "as"], [:string, "test"]],
        [:blockarg, [:keyword, "do"],
          [
            [:plaintext, " 1 "]
          ]]]
    )
    parse('{% if a1 then: %} 1 {% elsif: a2 then: %} 2 {% else: %} 3 {% end if %}').
              should have_node_structure(
      [:tag,
        [:ident, "if"],
        [:ident, "a1"],
        [:blockarg, [:keyword, "then"],
          [[:plaintext, " 1 "]]],
        [:kwarg, [:keyword, "elsif"], [:ident, "a2"]],
        [:blockarg, [:keyword, "then"],
          [[:plaintext, " 2 "]]],
        [:blockarg, [:keyword, "else"],
          [[:plaintext, " 3 "]]]]
    )
  end

  it "reports EOF errors" do
    expect { parse('{% if a1 then: %} 1 {% wat %}') }.to raise_error(Liquor::SyntaxError, %r|unexpected end of stream|)
  end

  it "handles lexer errors" do
    parser = Liquor::Parser.new
    parser.parse '{{ $'
    parser.success?.should == false
    parser.ast.should == nil
  end

  it "correctly handles multiple errors" do
    parser = Liquor::Parser.new
    parser.parse '{{ fun(a: 1 a: 1) + fun(b: 1 b: 1) }}'
    parser.errors.count.should == 2
    parser.ast.should_not == nil
  end

  it "resets error state on next parse" do
    parser = Liquor::Parser.new
    parser.parse '{{ fun(a: 1 a: 1) + fun(b: 1 b: 1) }}'
    parser.errors.count.should == 2
    parser.parse '{{ 1 }}'
    parser.errors.count.should == 0
    parser.success?.should == true
  end
end