require 'spec_helper'

describe Liquor::Lexer do
  it "parses plaintext" do
    lex("abc\ndef").should have_token_structure(
      [:plaintext, "abc\ndef"]
    )
  end

  it "parses plaintext with braces" do
    lex('abc { def').should have_token_structure( [:plaintext] )
    lex('abc \{ def').should have_token_structure( [:plaintext] )
    lex('abc \{% def').should have_token_structure( [:plaintext] )
    lex('abc \{{\{% def').should have_token_structure( [:plaintext] )
  end

  it "parses comments" do
    lex('abc {! def !} test').should have_token_structure(
      [:plaintext, 'abc '],
      [:plaintext, ' test']
    )
    lex('abc {! {% test %} !} test').should have_token_structure(
      [:plaintext, 'abc '],
      [:plaintext, ' test']
    )
    lex('abc {! {{ def }} !} test').should have_token_structure(
      [:plaintext, 'abc '],
      [:plaintext, ' test']
    )
    lex('abc {! test {! a !} b !} def').should have_token_structure(
      [:plaintext, 'abc '],
      [:plaintext, ' def'],
    )
  end

  it "parses blocks and interpolations" do
    lex('abc {{ def }}').should have_token_structure(
      [:plaintext],
      [:linterp],
      [:ident],
      [:rinterp],
    )
    lex('abc {% def %}').should have_token_structure(
      [:plaintext],
      [:lblock],
      [:ident],
      [:rblock],
    )
  end

  it "fails on nested blocks and interpolations" do
    expect { lex('abc {{ def {{') }.to raise_error(Liquor::SyntaxError, %r|unexpected `{'|)
    expect { lex('abc {{ def {%') }.to raise_error(Liquor::SyntaxError, %r|unexpected `{'|)
    expect { lex('abc {% def {{') }.to raise_error(Liquor::SyntaxError, %r|unexpected `{'|)
    expect { lex('abc {% def {%') }.to raise_error(Liquor::SyntaxError, %r|unexpected `{'|)
  end

  it "fails on unrecognized symbols" do
    expect { lex('abc {{ # }}') }.to raise_error(Liquor::SyntaxError, %r|unexpected `#'|)
  end

  it "fails invalid integer literals the correct way" do
    expect { lex('{{ 1a }}') }.to raise_error(Liquor::SyntaxError, %r|unexpected `a'|)
  end

  it "parses complex expressions" do
    lex('{{ 1 * 2 + substr("abc" from: 1 to: 10) }}').should have_token_structure(
      [:linterp],
      [:integer, 1], [:op_mul], [:integer, 2], [:op_plus],
      [:ident], [:lparen],
      [:string, "abc"],
      [:keyword, "from"], [:integer, 1],
      [:keyword, "to"],   [:integer, 10],
      [:rparen],
      [:rinterp],
    )
  end

  it "parses blocks with embedded blocks" do
    lex('{% for x in: [ 1, 2, q ] do: %} value: {{ x }} {% endfor %}').should have_token_structure(
      [:lblock],
      [:ident, "for"], [:ident, "x"],
      [:keyword, "in"],
      [:lbracket], [:integer, 1], [:comma], [:integer, 2], [:comma], [:ident, "q"], [:rbracket],
      [:keyword, "do"],
      [:rblock],
      [:plaintext],
      [:linterp], [:ident], [:rinterp],
      [:plaintext],
      [:lblock2], [:endtag], [:rblock],
    )
  end

  it "fails on multiline blocks and interpolations" do
    expect { lex("{% \n %}") }.to raise_error(Liquor::SyntaxError, %r|unexpected `\\n'|)
    expect { lex("{{ \n }}") }.to raise_error(Liquor::SyntaxError, %r|unexpected `\\n'|)
  end

  it "parses complex string literals" do
    expect { lex(%|{{ "test }}|) }.to raise_error(Liquor::SyntaxError, %r|literal not terminated|)
    expect { lex(%|{{ "test\\" }}|) }.to raise_error(Liquor::SyntaxError, %r|literal not terminated|)
    expect { lex(%|{{ "test\\\\" }}|) }.not_to raise_error

    expect { lex(%|{{ 'test }}|) }.to raise_error(Liquor::SyntaxError, %r|literal not terminated|)
    expect { lex(%|{{ 'test\\' }}|) }.to raise_error(Liquor::SyntaxError, %r|literal not terminated|)
    expect { lex(%|{{ 'test\\\\' }}|) }.not_to raise_error

    lex(%|{{ "test ' \\'" }}|).should have_token_structure(
      [:linterp], [:string, %|test ' \\'|], [:rinterp]
    )
    lex(%|{{ 'test " \\'' }}|).should have_token_structure(
      [:linterp], [:string, %|test " '|], [:rinterp]
    )

    expect { lex(%|{{ "test\n" }}|) }.to raise_error(Liquor::SyntaxError, %r|literal not terminated|)
  end

  it "parses nested tags correctly" do
    lex('{% a do: %} 1 {% b %} 2 {% c do: %} 3 {% endc %} 4 {% enda %} 5 {% ender %}').
            should have_token_structure(
      [:lblock], [:ident, "a"], [:keyword, "do"], [:rblock],
      [:plaintext, " 1 "],
      [:lblock], [:ident, "b"], [:rblock],
      [:plaintext, " 2 "],
      [:lblock], [:ident, "c"], [:keyword, "do"], [:rblock],
      [:plaintext, " 3 "],
      [:lblock2], [:endtag], [:rblock],
      [:plaintext, " 4 "],
      [:lblock2], [:endtag], [:rblock],
      [:plaintext, " 5 "],
      [:lblock], [:ident, "ender"], [:rblock],
    )
    lex('{% capture do: %}{% if a then: %} 1 {% elsif: b then: %} 2 {% endif %}{% endcapture %}').
            should have_token_structure(
      [:lblock], [:ident, "capture"], [:keyword, "do"], [:rblock],
      [:lblock], [:ident, "if"], [:ident, "a"], [:keyword, "then"], [:rblock],
      [:plaintext, " 1 "],
      [:lblock2], [:keyword, "elsif"], [:ident, "b"], [:keyword, "then"], [:rblock],
      [:plaintext, " 2 "],
      [:lblock2], [:endtag], [:rblock],
      [:lblock2], [:endtag], [:rblock],
    )
  end

  it "understands syntactic sugar for =" do
    lex('{% assign x = 1 %}').should have_token_structure(
      [:lblock], [:ident, "assign"], [:ident, "x"], [:keyword, "="], [:integer, 1], [:rblock]
    )
  end
end