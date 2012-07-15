%%{

machine liquor;

whitespace  = [\t ]+;
symbol      = [a-zA-Z_];
any_newline = '\n' @ { line_starts.push(p + 1) } | any;
identifier  = symbol ( symbol | digit )*;

keyword_argument = identifier ':';

lblock  = '{%';
rblock  = '%}';

linterp = '{{';
rinterp = '}}';

action string_append {
  string << data[p]
}

action string_end {
  tok.(:string, string); fgoto code;
}

dqstring := |*
    '\\"'  => { string << '"' };
    '\\\\' => { string << '\\' };
    '"'    => string_end;
    any @eof { runaway = true }
           => string_append;
*|;

sqstring := |*
    "\\'"  => { string << "'" };
    "\\\\" => { string << '\\' };
    "'"    => string_end;
    any @eof { runaway = true }
           => string_append;
*|;

tag_start := |*
    whitespace;

    lblock =>
      { tok.(:lblock) };

    'end' identifier =>
      { tag = data[ts + 3...te]
        if tag_stack.last == tag
          tok.(:endtag)
          tag_stack.pop
        else
          tok.(:tag, data[ts...te])
        end
        fgoto code;
      };

    identifier =>
      { tag = data[ts...te]
        tok.(:tag, tag)
        tag_stack.push tag
        fgoto code;
      };

    identifier ':' =>
      { tok.(:kwarg, data[ts...te - 1])
        fgoto code;
      };

    any =>
      { fhold; fgoto code; };
*|;

code := |*
    whitespace;

    keyword_argument => { tok.(:kwarg, data[ts...te-1]) };

    identifier => { tok.(:ident, data[ts...te]) };

    ( digit+ ) => { tok.(:integer, data[ts...te].to_i) };

    ',' => { tok.(:comma) };
    '.' => { tok.(:dot) };

    '[' => { tok.(:lbracket) };
    ']' => { tok.(:rbracket) };

    '(' => { tok.(:lparen) };
    ')' => { tok.(:rparen) };

    '|' => { tok.(:pipe) };

    '+' => { tok.(:op_plus) };
    '-' => { tok.(:op_minus) };
    '*' => { tok.(:op_mul) };
    '/' => { tok.(:op_div) };
    '%' => { tok.(:op_mod) };

    '==' => { tok.(:op_eq) };
    '!=' => { tok.(:op_neq) };
    '>'  => { tok.(:op_gt) };
    '>=' => { tok.(:op_gte) };
    '<'  => { tok.(:op_lt) };
    '<=' => { tok.(:op_lte) };

    '!' => { tok.(:op_not) };

    '"' => { lit_start = p; fgoto dqstring; };
    "'" => { lit_start = p; fgoto sqstring; };

    linterp => { tok.(:linterp) };
    rinterp => { tok.(:rinterp); fgoto plaintext; };

    rblock => { tok.(:rblock); fgoto plaintext; };

    any => {
      error = SyntaxError.new("unexpected #{data[p].inspect}",
        line:  line_starts.count - 1,
        start: p - line_starts.last,
        end:   p - line_starts.last)
      raise error
    };
*|;

plaintext := |*
    ( '\\{' [%{]? | any_newline - '{' )* =>
      { tok.(:plaintext, data[ts...te]); };

    '{%' =>
      { fhold; fhold; fgoto tag_start; };

    any_newline =>
      { fhold; fgoto code; };
*|;

}%%

module Liquor
  class SyntaxError < StandardError
    def initialize(message, options={})
      super("#{message} at line #{options[:line] + 1}, column #{options[:start] + 1}")
      @options = options
    end

    def decorate(source)
      line = source.lines.drop(@options[:line]).first
      pointer =  "~" * (@options[:start])
      pointer += "^" * (@options[:end] - @options[:start] + 1)
      [ line, pointer ]
    end
  end

  module Lexer
    %% write data;

    def self.lex(data)
      eof    = data.length
      ts     = nil # token start
      te     = nil # token end

      string  = ""

      lit_start = nil
      runaway   = false

      tag_stack = []

      line_starts = [0]

      find_line_start = ->(index) {
        line_starts.
            each_index.find { |i|
              line_starts[i + 1].nil? || line_starts[i + 1] > index
            }
      }
      pos = ->(index) {
        line_start_index = find_line_start.(index)
        [ line_start_index + 1, index - line_starts[line_start_index] ]
      }

      tokens = []

      tok = ->(type, *data) {
        sl, sc, el, ec = *pos.(ts), *pos.(te - 1)
        tokens << [type, { line: sl, start: sc, end: ec }, *data]
      }

      %% write init;
      %% write exec;

      if runaway
        line_start_index = find_line_start.(lit_start)
        line_start = line_starts[line_start_index]

        error = SyntaxError.new("literal not closed",
          line:  line_start_index,
          start: lit_start - line_start,
          end:   lit_start - line_start)
        raise error
      end

      tokens
    end
  end
end

if $0 == __FILE__
  require 'pp'
  [
    'abc \{{ def',
    'abc \{ def',
    'abc \{% def',
    'abc {% def test: 1 %}',
    'abc {% 1 # ',
    'abc {% for x in: [ 1, 2, q ] do: %} value: {{ x }} {% endfor %}',
    '{{ 1 * 2 + substr("abc" from: 1 to: 10) }}',
    '{{ a | b | c }}',
    '{{ "test\\" }}',
    '{{ "test\\\\" }}',
    '{{ "test" }}',
    %|
{% if length(params.test) == 1 then: %}
  Test has length 1.
{% elsif: length(params.test) == 2 then: %}
  Test has length 2.
{% else: %}
  Test has unidentified length.
{% endif %}
    |
  ].each do |str|
    puts "INPUT: #{str}"
    begin
      pp Liquor::Lexer.lex(str)
    rescue Liquor::SyntaxError => e
      puts "Syntax error: #{e.message}"
      puts e.decorate(str)
    end
  end
end