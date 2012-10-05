#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.8
# from Racc grammer file "".
#

require 'racc/parser.rb'
module Liquor
  class Parser < Racc::Parser

module_eval(<<'...end parser.racc/module_eval...', 'parser.racc', 190)
  attr_reader :errors, :ast

  def initialize(tags={})
    super()

    @errors = []
    @ast    = nil
    @tags   = tags
  end

  def success?
    @errors.empty?
  end

  def parse(string, name='(code)')
    @errors.clear
    @name = name
    @ast  = nil

    begin
      @stream = Lexer.lex(string, @name, @tags)
      @ast = do_parse
    rescue Liquor::SyntaxError => e
      @errors << e
    end

    success?
  end

  def next_token
    tok = @stream.shift
    [ tok[0], tok ] if tok
  end

  TOKEN_NAME_MAP = {
    :comma    => ',',
    :dot      => '.',
    :lblock   => '{%',
    :rblock   => '%}',
    :linterp  => '{{',
    :rinterp  => '}}',
    :lbracket => '[',
    :rbracket => ']',
    :lparen   => '(',
    :rparen   => ')',
    :pipe     => '|',
    :op_not   => '!',
    :op_mul   => '*',
    :op_div   => '/',
    :op_mod   => '%',
    :op_plus  => '+',
    :op_minus => '-',
    :op_eq    => '==',
    :op_neq   => '!=',
    :op_lt    => '<',
    :op_leq   => '<=',
    :op_gt    => '>',
    :op_geq   => '>=',
    :keyword  => 'keyword argument name',
    :kwarg    => 'keyword argument',
    :ident    => 'identifier',
  }

  def on_error(error_token_id, error_token, value_stack)
    if token_to_str(error_token_id) == "$end"
      raise Liquor::SyntaxError.new("unexpected end of program", {
        file: @name
      })
    else
      type, (loc, value) = error_token
      type = TOKEN_NAME_MAP[type] || type

      raise Liquor::SyntaxError.new("unexpected token `#{type}'", loc)
    end
  end

  def retag(nodes)
    loc = nodes.map { |node| node[1] }.compact
    first, *, last = loc
    return first if last.nil?

    {
      file:  first[:file],
      line:  first[:line],
      start: first[:start],
      end:    last[:end],
    }
  end

  def reduce_tag_args(list)
    list.each_slice(2).reduce([]) { |args, (k, v)|
      if v[0] == :block
        args << [ :blockarg, retag([ k, v ]), k, v[2] || [] ]
      else
        args << [ :kwarg,    retag([ k, v ]), k, v          ]
      end
    }
  end
...end parser.racc/module_eval...
##### State transition tables begin ###

racc_action_table = [
    76,    26,    26,     6,    96,    41,     5,    97,    25,    25,
    23,    28,    32,    36,    37,    34,    35,    31,    29,    27,
    33,     2,    30,    96,    26,    26,    97,     6,    25,    74,
     5,    25,    25,    38,    39,    28,    32,    36,    37,    34,
    35,    31,    29,    27,    33,     2,    30,    96,    26,    26,
    97,     6,    70,    22,     5,    25,    25,    38,    39,    28,
    32,    36,    37,    34,    35,    31,    29,    27,    33,     2,
    30,    94,    43,    26,    98,     6,    77,   102,     5,    43,
    25,    38,    39,    28,    32,    36,    37,    34,    35,    31,
    29,    27,    33,     2,    30,    87,    54,    26,   107,     6,
     7,    74,     5,    84,    25,    38,    39,    28,    32,    36,
    37,    34,    35,    31,    29,    27,    33,     2,    30,   111,
    70,    26,   nil,     6,    75,   nil,     5,   nil,    25,    38,
    39,    28,    32,    36,    37,    34,    35,    31,    29,    27,
    33,     2,    30,   nil,   nil,   nil,    82,   nil,    26,    96,
   nil,   nil,    97,    38,    39,    25,   nil,   nil,    28,    32,
    36,    37,    34,    35,    31,    29,    27,    33,   nil,    30,
   nil,   nil,    26,   nil,     6,   nil,    74,     5,   nil,    25,
    38,    39,    28,    32,    36,    37,    34,    35,    31,    29,
    27,    33,     2,    30,   nil,   nil,    26,   nil,   nil,   nil,
   nil,   nil,   nil,    25,    38,    39,    28,    32,    36,    37,
    34,    35,    31,    29,    27,    33,   nil,    30,    40,   nil,
    26,   nil,    24,   nil,    52,   nil,   nil,    25,    38,    39,
    28,    32,    36,    37,    34,    35,    31,    29,    27,    33,
   nil,    30,   nil,   nil,    51,   nil,   nil,    26,   nil,   nil,
   nil,    52,    38,    39,    25,   nil,   nil,    28,    32,    36,
    37,    34,    35,    31,    29,    27,    33,   nil,    30,   nil,
   nil,    51,   nil,   nil,    26,   nil,   nil,   nil,   nil,    38,
    39,    25,   nil,   nil,    28,    32,    36,    37,    34,    35,
    31,    29,    27,    33,   nil,    30,    13,    15,   nil,   nil,
   nil,    21,   nil,    14,   nil,   nil,    38,   nil,   nil,   nil,
    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,   nil,
   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,    19,
   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,   nil,
    18,    13,    15,    52,    19,   nil,    21,   nil,    14,   nil,
   nil,   nil,    16,   nil,   nil,    18,   nil,    13,    15,    19,
   nil,   nil,    21,    51,    14,   nil,   nil,    16,   nil,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,   nil,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,   nil,    19,   nil,    21,   nil,    14,
   nil,   nil,   nil,    16,   nil,   nil,    18,    13,    15,    74,
    19,   nil,    21,   nil,    14,   nil,   nil,   nil,    16,   nil,
   nil,    18,    13,    15,    26,    19,   nil,    21,   nil,    14,
   nil,    25,   nil,    16,    28,   nil,    18,   nil,    13,    15,
    19,    29,    27,    21,   101,    14,   nil,   nil,    16,   nil,
   nil,   nil,    18,   nil,    13,    15,    19,   nil,   nil,    21,
    81,    14,   nil,   nil,    16,   nil,   nil,   nil,    18,   nil,
    13,    15,    19,   nil,   nil,    21,   106,    14,   nil,   nil,
    16,   nil,   nil,   nil,    18,    13,    15,    26,    19,   nil,
    21,    26,    14,   nil,    25,   nil,    16,    28,    25,    18,
   nil,    28,   nil,    19,    29,    27,    26,    31,    29,    27,
   nil,    16,    30,    25,   nil,   nil,    28,   nil,    26,   nil,
   nil,   nil,    31,    29,    27,    25,   nil,    30,    28,    32,
    36,    37,    34,    35,    31,    29,    27,    33,    26,    30,
   nil,   nil,   nil,   nil,   nil,    25,   nil,   nil,    28,   nil,
    26,   nil,   nil,   nil,    31,    29,    27,    25,   nil,    30,
    28,   nil,    26,   nil,   nil,   nil,    31,    29,    27,    25,
   nil,    30,    28,   nil,    26,   nil,   nil,   nil,    31,    29,
    27,    25,   nil,    30,    28,   nil,   nil,   nil,   nil,   nil,
    31,    29,    27,   nil,   nil,    30 ]

racc_action_check = [
    47,    47,    55,     0,   107,    12,     0,   107,    47,    55,
     7,    47,    47,    47,    47,    47,    47,    47,    47,    47,
    47,     0,    47,   111,    56,    88,   111,   106,    45,    88,
   106,    56,    88,    47,    47,    88,    88,    88,    88,    88,
    88,    88,    88,    88,    88,   106,    88,    94,    57,    46,
    94,     2,    84,     6,     2,    57,    46,    88,    88,    46,
    46,    46,    46,    46,    46,    46,    46,    46,    46,     2,
    46,    91,    13,    99,    96,   101,    48,    99,   101,    54,
    99,    46,    46,    99,    99,    99,    99,    99,    99,    99,
    99,    99,    99,   101,    99,    72,    26,    44,   103,     3,
     1,    70,     3,    69,    44,    99,    99,    44,    44,    44,
    44,    44,    44,    44,    44,    44,    44,     3,    44,   109,
    40,    53,   nil,     4,    44,   nil,     4,   nil,    53,    44,
    44,    53,    53,    53,    53,    53,    53,    53,    53,    53,
    53,     4,    53,   nil,   nil,   nil,    53,   nil,   104,   104,
   nil,   nil,   104,    53,    53,   104,   nil,   nil,   104,   104,
   104,   104,   104,   104,   104,   104,   104,   104,   nil,   104,
   nil,   nil,    71,   nil,    81,   nil,    71,    81,   nil,    71,
   104,   104,    71,    71,    71,    71,    71,    71,    71,    71,
    71,    71,    81,    71,   nil,   nil,    11,   nil,   nil,   nil,
   nil,   nil,   nil,    11,    71,    71,    11,    11,    11,    11,
    11,    11,    11,    11,    11,    11,   nil,    11,    11,   nil,
    49,   nil,    11,   nil,    49,   nil,   nil,    49,    11,    11,
    49,    49,    49,    49,    49,    49,    49,    49,    49,    49,
   nil,    49,   nil,   nil,    49,   nil,   nil,    79,   nil,   nil,
   nil,    79,    49,    49,    79,   nil,   nil,    79,    79,    79,
    79,    79,    79,    79,    79,    79,    79,   nil,    79,   nil,
   nil,    79,   nil,   nil,    67,   nil,   nil,   nil,   nil,    79,
    79,    67,   nil,   nil,    67,    67,    67,    67,    67,    67,
    67,    67,    67,    67,   nil,    67,    27,    27,   nil,   nil,
   nil,    27,   nil,    27,   nil,   nil,    67,   nil,   nil,   nil,
    27,    19,    19,   nil,    27,   nil,    19,   nil,    19,   nil,
   nil,   nil,    27,   nil,   nil,    19,    21,    21,   nil,    19,
   nil,    21,   nil,    21,   nil,   nil,   nil,    19,   nil,   nil,
    21,    22,    22,    22,    21,   nil,    22,   nil,    22,   nil,
   nil,   nil,    21,   nil,   nil,    22,   nil,    25,    25,    22,
   nil,   nil,    25,    22,    25,   nil,   nil,    22,   nil,   nil,
   nil,    25,    14,    14,   nil,    25,   nil,    14,   nil,    14,
   nil,   nil,   nil,    25,   nil,   nil,    14,    18,    18,   nil,
    14,   nil,    18,   nil,    18,   nil,   nil,   nil,    14,   nil,
   nil,    18,    74,    74,   nil,    18,   nil,    74,   nil,    74,
   nil,   nil,   nil,    18,   nil,   nil,    74,    29,    29,   nil,
    74,   nil,    29,   nil,    29,   nil,   nil,   nil,    74,   nil,
   nil,    29,    30,    30,   nil,    29,   nil,    30,   nil,    30,
   nil,   nil,   nil,    29,   nil,   nil,    30,    76,    76,   nil,
    30,   nil,    76,   nil,    76,   nil,   nil,   nil,    30,   nil,
   nil,    76,    32,    32,   nil,    76,   nil,    32,   nil,    32,
   nil,   nil,   nil,    76,   nil,   nil,    32,    33,    33,   nil,
    32,   nil,    33,   nil,    33,   nil,   nil,   nil,    32,   nil,
   nil,    33,    34,    34,   nil,    33,   nil,    34,   nil,    34,
   nil,   nil,   nil,    33,   nil,   nil,    34,    35,    35,   nil,
    34,   nil,    35,   nil,    35,   nil,   nil,   nil,    34,   nil,
   nil,    35,    36,    36,   nil,    35,   nil,    36,   nil,    36,
   nil,   nil,   nil,    35,   nil,   nil,    36,    37,    37,   nil,
    36,   nil,    37,   nil,    37,   nil,   nil,   nil,    36,   nil,
   nil,    37,    38,    38,   nil,    37,   nil,    38,   nil,    38,
   nil,   nil,   nil,    37,   nil,   nil,    38,    39,    39,   nil,
    38,   nil,    39,   nil,    39,   nil,   nil,   nil,    38,   nil,
   nil,    39,     5,     5,   nil,    39,   nil,     5,   nil,     5,
   nil,   nil,   nil,    39,   nil,   nil,     5,    43,    43,    43,
     5,   nil,    43,   nil,    43,   nil,   nil,   nil,     5,   nil,
   nil,    43,    97,    97,    59,    43,   nil,    97,   nil,    97,
   nil,    59,   nil,    43,    59,   nil,    97,   nil,    52,    52,
    97,    59,    59,    52,    97,    52,   nil,   nil,    97,   nil,
   nil,   nil,    52,   nil,   102,   102,    52,   nil,   nil,   102,
    52,   102,   nil,   nil,    52,   nil,   nil,   nil,   102,   nil,
    28,    28,   102,   nil,   nil,    28,   102,    28,   nil,   nil,
   102,   nil,   nil,   nil,    28,    31,    31,    58,    28,   nil,
    31,    64,    31,   nil,    58,   nil,    28,    58,    64,    31,
   nil,    64,   nil,    31,    58,    58,    65,    64,    64,    64,
   nil,    31,    64,    65,   nil,   nil,    65,   nil,    66,   nil,
   nil,   nil,    65,    65,    65,    66,   nil,    65,    66,    66,
    66,    66,    66,    66,    66,    66,    66,    66,    63,    66,
   nil,   nil,   nil,   nil,   nil,    63,   nil,   nil,    63,   nil,
    62,   nil,   nil,   nil,    63,    63,    63,    62,   nil,    63,
    62,   nil,    61,   nil,   nil,   nil,    62,    62,    62,    61,
   nil,    62,    61,   nil,    60,   nil,   nil,   nil,    61,    61,
    61,    60,   nil,    61,    60,   nil,   nil,   nil,   nil,   nil,
    60,    60,    60,   nil,   nil,    60 ]

racc_action_pointer = [
    -5,   100,    43,    91,   115,   577,    48,    10,   nil,   nil,
   nil,   193,   -24,    60,   367,   nil,   nil,   nil,   382,   306,
   nil,   321,   336,   nil,   nil,   352,    91,   291,   655,   412,
   427,   670,   457,   472,   487,   502,   517,   532,   547,   562,
   115,   nil,   nil,   592,    94,    18,    46,    -2,    48,   217,
   nil,   nil,   623,   118,    67,    -1,    21,    45,   674,   611,
   761,   749,   737,   725,   678,   693,   705,   271,   nil,    78,
    94,   169,    65,   nil,   397,   nil,   442,   nil,   nil,   244,
   nil,   166,   nil,   nil,    47,   nil,   nil,   nil,    22,   nil,
   nil,    62,   nil,   nil,    43,   nil,    47,   607,   nil,    70,
   nil,    67,   639,    89,   145,   nil,    19,     0,   nil,   110,
   nil,    19,   nil ]

racc_action_default = [
    -1,   -57,    -1,    -1,    -1,   -57,   -57,   -57,    -2,    -3,
    -4,   -57,   -57,    -7,   -57,    -9,   -10,   -11,   -57,   -57,
   -31,   -35,   -57,   113,    -5,   -57,   -57,   -57,   -57,   -57,
   -57,   -57,   -57,   -57,   -57,   -57,   -57,   -57,   -57,   -57,
   -57,    -6,   -12,   -40,   -57,   -16,   -17,   -34,   -57,   -57,
   -46,   -47,   -57,   -57,   -15,   -18,   -19,   -20,   -21,   -22,
   -23,   -24,   -25,   -26,   -27,   -28,   -29,   -30,   -41,   -43,
   -40,   -40,   -57,   -38,   -57,    -8,   -35,   -32,   -45,   -57,
   -48,    -1,   -13,   -14,   -57,   -44,   -37,   -36,   -40,   -33,
   -50,   -57,   -42,   -39,   -57,   -49,   -57,   -57,   -51,   -57,
   -52,    -1,   -57,   -57,   -57,   -54,    -1,   -57,   -56,   -57,
   -53,   -57,   -55 ]

racc_goto_table = [
     1,    11,     8,     9,    10,    48,    68,    80,    42,    50,
    44,    12,    72,    73,    45,    46,   100,   105,    49,   nil,
   nil,    53,   nil,    55,    56,    57,    58,    59,    60,    61,
    62,    63,    64,    65,    66,    67,    78,   nil,   nil,    71,
    85,    86,    95,   nil,   nil,   nil,   nil,   nil,    79,    83,
    92,   nil,   108,   nil,   nil,   110,   nil,   nil,    93,   112,
    89,   nil,   nil,   nil,   nil,   nil,    90,   nil,   nil,   nil,
    88,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    91,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    99,   nil,   nil,   nil,   nil,   104,   nil,
   nil,   103,   nil,   nil,   nil,   nil,   109 ]

racc_goto_check = [
     1,     4,     1,     1,     1,     9,    12,    15,     8,    14,
     4,     5,    10,    11,     4,     4,    17,    18,     4,   nil,
   nil,     4,   nil,     4,     4,     4,     4,     4,     4,     4,
     4,     4,     4,     4,     4,     4,    14,   nil,   nil,     4,
    11,    11,    16,   nil,   nil,   nil,   nil,   nil,     4,     8,
    12,   nil,    16,   nil,   nil,    16,   nil,   nil,    11,    16,
     9,   nil,   nil,   nil,   nil,   nil,    14,   nil,   nil,   nil,
     4,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     1,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,     4,   nil,   nil,   nil,   nil,     4,   nil,
   nil,     1,   nil,   nil,   nil,   nil,     1 ]

racc_goto_pointer = [
   nil,     0,   nil,   nil,    -4,     6,   nil,   nil,    -5,   -16,
   -31,   -30,   -34,   nil,   -13,   -45,   -52,   -81,   -85 ]

racc_goto_default = [
   nil,   nil,     3,     4,    47,   nil,    20,    17,   nil,   nil,
   nil,   nil,   nil,    69,   nil,   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 38, :_reduce_none,
  2, 38, :_reduce_2,
  2, 38, :_reduce_3,
  2, 38, :_reduce_4,
  3, 39, :_reduce_5,
  3, 39, :_reduce_6,
  1, 43, :_reduce_none,
  3, 43, :_reduce_8,
  1, 41, :_reduce_none,
  1, 41, :_reduce_none,
  1, 41, :_reduce_none,
  2, 41, :_reduce_12,
  4, 41, :_reduce_13,
  4, 41, :_reduce_14,
  3, 41, :_reduce_15,
  2, 41, :_reduce_16,
  2, 41, :_reduce_17,
  3, 41, :_reduce_18,
  3, 41, :_reduce_19,
  3, 41, :_reduce_20,
  3, 41, :_reduce_21,
  3, 41, :_reduce_22,
  3, 41, :_reduce_23,
  3, 41, :_reduce_24,
  3, 41, :_reduce_25,
  3, 41, :_reduce_26,
  3, 41, :_reduce_27,
  3, 41, :_reduce_28,
  3, 41, :_reduce_29,
  3, 41, :_reduce_30,
  1, 41, :_reduce_none,
  3, 44, :_reduce_32,
  3, 46, :_reduce_33,
  1, 46, :_reduce_34,
  0, 46, :_reduce_35,
  3, 45, :_reduce_36,
  2, 47, :_reduce_37,
  1, 47, :_reduce_38,
  3, 48, :_reduce_39,
  0, 48, :_reduce_40,
  3, 42, :_reduce_41,
  3, 49, :_reduce_42,
  1, 49, :_reduce_43,
  2, 50, :_reduce_44,
  4, 40, :_reduce_45,
  3, 40, :_reduce_46,
  1, 51, :_reduce_47,
  2, 51, :_reduce_48,
  4, 52, :_reduce_49,
  2, 52, :_reduce_50,
  2, 53, :_reduce_51,
  2, 53, :_reduce_52,
  4, 54, :_reduce_53,
  3, 54, :_reduce_54,
  4, 55, :_reduce_55,
  2, 55, :_reduce_56 ]

racc_reduce_n = 57

racc_shift_n = 113

racc_token_table = {
  false => 0,
  :error => 1,
  :comma => 2,
  :dot => 3,
  :endtag => 4,
  :ident => 5,
  :integer => 6,
  :keyword => 7,
  :lblock => 8,
  :lblock2 => 9,
  :lbracket => 10,
  :linterp => 11,
  :lparen => 12,
  :op_div => 13,
  :op_eq => 14,
  :op_gt => 15,
  :op_geq => 16,
  :op_lt => 17,
  :op_leq => 18,
  :op_minus => 19,
  :op_mod => 20,
  :op_mul => 21,
  :op_neq => 22,
  :op_not => 23,
  :op_plus => 24,
  :pipe => 25,
  :plaintext => 26,
  :rblock => 27,
  :rbracket => 28,
  :rinterp => 29,
  :rparen => 30,
  :string => 31,
  :tag_ident => 32,
  :op_uminus => 33,
  :op_neg => 34,
  :op_and => 35,
  :op_or => 36 }

racc_nt_base = 37

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "comma",
  "dot",
  "endtag",
  "ident",
  "integer",
  "keyword",
  "lblock",
  "lblock2",
  "lbracket",
  "linterp",
  "lparen",
  "op_div",
  "op_eq",
  "op_gt",
  "op_geq",
  "op_lt",
  "op_leq",
  "op_minus",
  "op_mod",
  "op_mul",
  "op_neq",
  "op_not",
  "op_plus",
  "pipe",
  "plaintext",
  "rblock",
  "rbracket",
  "rinterp",
  "rparen",
  "string",
  "tag_ident",
  "op_uminus",
  "op_neg",
  "op_and",
  "op_or",
  "$start",
  "block",
  "interp",
  "tag",
  "expr",
  "filter_chain",
  "primary_expr",
  "tuple",
  "function_args",
  "tuple_content",
  "function_args_inside",
  "function_keywords",
  "filter_chain_cont",
  "filter_call",
  "tag_first_cont",
  "tag_first_cont2",
  "tag_next_cont",
  "tag_next_cont2",
  "tag_next_cont3" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

# reduce 1 omitted

module_eval(<<'.,.,', 'parser.racc', 23)
  def _reduce_2(val, _values, result)
     result = [ val[0], *val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 25)
  def _reduce_3(val, _values, result)
     result = [ val[0], *val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 27)
  def _reduce_4(val, _values, result)
     result = [ val[0], *val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 31)
  def _reduce_5(val, _values, result)
     result = [ :interp, retag(val), val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 33)
  def _reduce_6(val, _values, result)
     result = [ :interp, retag(val), val[1] ] 
    result
  end
.,.,

# reduce 7 omitted

module_eval(<<'.,.,', 'parser.racc', 38)
  def _reduce_8(val, _values, result)
     result = [ val[1][0], retag(val), *val[1][2..-1] ] 
    result
  end
.,.,

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

module_eval(<<'.,.,', 'parser.racc', 45)
  def _reduce_12(val, _values, result)
     result = [ :call,   retag(val), val[0], val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 47)
  def _reduce_13(val, _values, result)
     result = [ :index,  retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 49)
  def _reduce_14(val, _values, result)
     result = [ :external, retag(val), val[0], val[2], val[3] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 51)
  def _reduce_15(val, _values, result)
     result = [ :external, retag(val), val[0], val[2], nil ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 53)
  def _reduce_16(val, _values, result)
     result = [ :uminus, retag(val), val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 55)
  def _reduce_17(val, _values, result)
     result = [ :not, retag(val), val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 57)
  def _reduce_18(val, _values, result)
     result = [ :mul, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 59)
  def _reduce_19(val, _values, result)
     result = [ :div, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 61)
  def _reduce_20(val, _values, result)
     result = [ :mod, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 63)
  def _reduce_21(val, _values, result)
     result = [ :plus, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 65)
  def _reduce_22(val, _values, result)
     result = [ :minus, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 67)
  def _reduce_23(val, _values, result)
     result = [ :eq, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 69)
  def _reduce_24(val, _values, result)
     result = [ :neq, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 71)
  def _reduce_25(val, _values, result)
     result = [ :lt, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 73)
  def _reduce_26(val, _values, result)
     result = [ :leq, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 75)
  def _reduce_27(val, _values, result)
     result = [ :gt, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 77)
  def _reduce_28(val, _values, result)
     result = [ :geq, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 79)
  def _reduce_29(val, _values, result)
     result = [ :and, retag(val), val[0], val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 81)
  def _reduce_30(val, _values, result)
     result = [ :or, retag(val), val[0], val[2] ] 
    result
  end
.,.,

# reduce 31 omitted

module_eval(<<'.,.,', 'parser.racc', 86)
  def _reduce_32(val, _values, result)
     result = [ :tuple, retag(val), val[1].compact ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 90)
  def _reduce_33(val, _values, result)
     result = [ val[0], *val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 92)
  def _reduce_34(val, _values, result)
     result = [ val[0] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 94)
  def _reduce_35(val, _values, result)
     result = [ ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 98)
  def _reduce_36(val, _values, result)
     result = [ :args, retag(val), *val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 102)
  def _reduce_37(val, _values, result)
     result = [ val[0], val[1][2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 104)
  def _reduce_38(val, _values, result)
     result = [ nil,    val[0][2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 108)
  def _reduce_39(val, _values, result)
     name = val[0][2].to_sym
        tail = val[2][2]
        loc  = retag([ val[0], val[1] ])

        if tail.include? name
          @errors << SyntaxError.new("duplicate keyword argument `#{val[0][2]}'",
              tail[name][1])
        end

        hash = {
          name => [ val[1][0], loc, *val[1][2..-1] ]
        }.merge(tail)

        result = [ :keywords, retag([ loc, val[2] ]), hash ]
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 124)
  def _reduce_40(val, _values, result)
     result = [ :keywords, nil, {} ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 128)
  def _reduce_41(val, _values, result)
     result = [ val[0], *val[2] ].
            reduce { |tree, node| node[3][2] = tree; node }
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 134)
  def _reduce_42(val, _values, result)
     result = [ val[0], *val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 136)
  def _reduce_43(val, _values, result)
     result = [ val[0] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 140)
  def _reduce_44(val, _values, result)
     ident_loc = val[0][1]
        empty_args_loc = { line:  ident_loc[:line],
                           start: ident_loc[:end] + 1,
                           end:   ident_loc[:end] + 1, }
        result = [ :call, val[0][1], val[0],
                   [ :args, val[1][1] || empty_args_loc, nil, val[1][2] ] ]
      
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 150)
  def _reduce_45(val, _values, result)
     result = [ :tag, retag(val), val[1], val[2], *reduce_tag_args(val[3][2]) ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 152)
  def _reduce_46(val, _values, result)
     result = [ :tag, retag(val), val[1], nil,    *reduce_tag_args(val[2][2]) ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 160)
  def _reduce_47(val, _values, result)
     result = [ :cont,  retag(val), [] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 162)
  def _reduce_48(val, _values, result)
     result = [ :cont,  retag(val), [ val[0], *val[1][2] ] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 166)
  def _reduce_49(val, _values, result)
     result = [ :cont2, val[0][1],  [ [:block, val[0][1], val[1] ], *val[3] ] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 168)
  def _reduce_50(val, _values, result)
     result = [ :cont2, retag(val), [ val[0], *val[1][2] ] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 172)
  def _reduce_51(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 174)
  def _reduce_52(val, _values, result)
     result = [ val[0], *val[1] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 178)
  def _reduce_53(val, _values, result)
     result = [ [:block, val[0][1], val[1] ], *val[3] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 180)
  def _reduce_54(val, _values, result)
     result = [ val[0], val[1], *val[2] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 184)
  def _reduce_55(val, _values, result)
     result = [ [:block, val[0][1], val[1] ], *val[3] ] 
    result
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 186)
  def _reduce_56(val, _values, result)
     result = [ val[0], *val[1] ] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

  end   # class Parser
  end   # module Liquor