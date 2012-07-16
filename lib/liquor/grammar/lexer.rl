%%{

machine liquor;

whitespace  = [\t ]+;
symbol      = [a-zA-Z_];
any_newline = '\n' @ { line_starts.push(p + 1) } | any;
identifier  = symbol ( symbol | digit )*;

lblock  = '{%';
rblock  = '%}';

linterp = '{{';
rinterp = '}}';

action string_append {
  string << data[p]
}

action string_end {
  tok.(:string, string, ts: str_start); fgoto code;
}

action runaway {
  runaway = true
}

action error {
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
}

dqstring := |*
    '\\"'  => { string << '"' };
    '\\\\' => { string << '\\' };
    '"'    => string_end;
    [^\n] @eof runaway
           => string_append;
    "\n"   => runaway;
*|;

sqstring := |*
    "\\'"  => { string << "'" };
    "\\\\" => { string << '\\' };
    "'"    => string_end;
    [^\n] @eof runaway
           => string_append;
    "\n"   => runaway;
*|;

integer := |*
    digit+  => { tok.(:integer, data[ts...te].to_i) };
    symbol  => error;
    any     => { fhold; fgoto code; };
*|;

tag_start := |*
    whitespace;

    'end' identifier =>
      { tag = data[ts + 3...te]
        if tag_stack.last == tag
          fixtok.(:lblock2)
          tok.(:endtag)
          tag_stack.pop
        else
          tok.(:ident, data[ts...te])
        end
        fgoto code;
      };

    identifier =>
      { tag = data[ts...te]
        tok.(:ident, tag)
        last_tag = tag
        fgoto code;
      };

    identifier ':' =>
      { fixtok.(:lblock2)
        tok.(:keyword, data[ts...te - 1])
        fgoto code;
      };

    any =>
      { fhold; fgoto code; };
*|;

code := |*
    whitespace;

    identifier => { tok.(:ident, data[ts...te]) };

    digit => { fhold; fgoto integer; };

    identifier %{ kw_stop = p } ':' whitespace* rblock =>
      { tok.(:keyword, data[ts...kw_stop], te: kw_stop)
        tok.(:rblock,  nil,                ts: te - 2)
        if last_tag
          tag_stack.push last_tag
          last_tag = nil
        end
        fgoto plaintext;
      };

    identifier ':' =>
      { tok.(:keyword, data[ts...te-1]) };

    ','  => { tok.(:comma) };
    '.'  => { tok.(:dot)   };

    '['  => { tok.(:lbracket) };
    ']'  => { tok.(:rbracket) };

    '('  => { tok.(:lparen) };
    ')'  => { tok.(:rparen) };

    '|'  => { tok.(:pipe) };

    '+'  => { tok.(:op_plus)  };
    '-'  => { tok.(:op_minus) };
    '*'  => { tok.(:op_mul)   };
    '/'  => { tok.(:op_div)   };
    '%'  => { tok.(:op_mod)   };

    '==' => { tok.(:op_eq)  };
    '!=' => { tok.(:op_neq) };
    '>'  => { tok.(:op_gt)  };
    '>=' => { tok.(:op_geq) };
    '<'  => { tok.(:op_lt)  };
    '<=' => { tok.(:op_leq) };

    '!'  => { tok.(:op_not) };

    '&&' => { tok.(:op_and) };
    '||' => { tok.(:op_or) };

    '"'  => { str_start = p; fgoto dqstring; };
    "'"  => { str_start = p; fgoto sqstring; };

    rinterp => { tok.(:rinterp); fgoto plaintext; };
    rblock  => { tok.(:rblock);  fgoto plaintext; };

    any => error;
*|;

plaintext := |*
    ( '\\{' [%{]? | '{' [^%{] | any_newline - '{' )* =>
      { tok.(:plaintext, data[ts...te]); };

    '{{' =>
      { tok.(:linterp); fgoto code; };

    '{%' =>
      { tok.(:lblock);  fgoto tag_start; };

    any_newline =>
      { fhold; fgoto code; };
*|;

}%%

module Liquor
  module Lexer
    %% write data;

    def self.lex(data)
      eof    = data.length
      ts     = nil # token start
      te     = nil # token end

      # Strings
      string    = ""
      str_start = nil
      runaway   = false

      # Tags
      tag_stack = []
      last_tag  = nil
      kw_stop   = nil

      line_starts = [0]

      find_line_start = ->(index) {
        line_starts.
            each_index.find { |i|
              line_starts[i + 1].nil? || line_starts[i + 1] > index
            }
      }
      pos = ->(index) {
        line_start_index = find_line_start.(index)
        [ line_start_index, index - line_starts[line_start_index] ]
      }

      tokens = []

      fixtok = ->(new_type) {
        tokens.last[0] = new_type
      }
      tok = ->(type, data=nil, options={}) {
        sl, sc, el, ec = *pos.(options[:ts] || ts),
                         *pos.(options[:te] || te - 1)
        tokens << [type, { line: sl, start: sc, end: ec }, *data]
      }

      %% write init;
      %% write exec;

      if runaway
        line_start_index = find_line_start.(str_start)
        line_start = line_starts[line_start_index]

        error = SyntaxError.new("literal not terminated",
          line:  line_start_index,
          start: str_start - line_start,
          end:   str_start - line_start)
        raise error
      end

      tokens
    end
  end
end