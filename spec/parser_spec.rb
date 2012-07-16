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
                  {"from" => [:integer, 1]}]]]
    )
    parse('{{ a(from: 1 to: 2) }}').should have_node_structure(
      [:interp,
        [:call,
          [:ident, "a"],
          [:args, nil,
                  {"from" => [:integer, 1],
                   "to"   => [:integer, 2]}]]]
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
            [:call,
              [:ident, "a"],
              [:args,
                nil,
                {}]],
            {}]]]
    )
    parse('{{ a x: 1 | b y: 2 z: 3 | c p: 4 }}').should have_node_structure(
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
                    { "x" => [:integer, 1] }]],
                { "y" => [:integer, 2],
                  "z" => [:integer, 3] }]],
            { "p" => [:integer, 4] }]]]
    )
  end

  it "rejects malformed filter expressions" do
    expect { parse('{{ a b: 1 }}') }.to raise_error(Liquor::SyntaxError)
    expect { parse('{{ a(b: 1) | b ') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `|'})
    expect { parse('{{ a("str", b: 1) | b ') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `|'})
    expect { parse('{{ a | b(b: 1)') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `\('})
    expect { parse('{{ a | b("str", b: 1)') }.to raise_error(Liquor::SyntaxError, %r{unexpected token `\('})
  end
end