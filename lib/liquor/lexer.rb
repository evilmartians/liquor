
# line 1 "lib/liquor/grammar/lexer.rl"

# line 179 "lib/liquor/grammar/lexer.rl"


module Liquor
  module Lexer
    
# line 11 "lib/liquor/lexer.rb"
class << self
	attr_accessor :_liquor_actions
	private :_liquor_actions, :_liquor_actions=
end
self._liquor_actions = [
	0, 1, 1, 1, 3, 1, 4, 1, 
	5, 1, 6, 1, 7, 1, 8, 1, 
	9, 1, 10, 1, 11, 1, 12, 1, 
	13, 1, 14, 1, 15, 1, 16, 1, 
	17, 1, 18, 1, 19, 1, 20, 1, 
	21, 1, 22, 1, 23, 1, 24, 1, 
	25, 1, 26, 1, 27, 1, 28, 1, 
	29, 1, 30, 1, 31, 1, 32, 1, 
	33, 1, 34, 1, 35, 1, 36, 1, 
	37, 1, 38, 1, 39, 1, 40, 1, 
	41, 1, 42, 1, 43, 1, 44, 1, 
	45, 1, 46, 1, 47, 1, 48, 1, 
	49, 1, 50, 1, 51, 1, 52, 1, 
	53, 1, 54, 1, 55, 1, 56, 1, 
	57, 1, 58, 1, 59, 1, 60, 1, 
	61, 1, 62, 1, 63, 1, 64, 1, 
	65, 1, 66, 1, 67, 1, 68, 1, 
	69, 1, 70, 2, 5, 0, 2, 5, 
	2
]

class << self
	attr_accessor :_liquor_key_offsets
	private :_liquor_key_offsets, :_liquor_key_offsets=
end
self._liquor_key_offsets = [
	0, 3, 8, 11, 12, 15, 18, 21, 
	23, 26, 28, 29, 30, 33, 35, 38, 
	40, 47, 49, 57, 59, 67, 76, 85, 
	94, 101, 130, 132, 133, 134, 135, 136, 
	137, 138, 146, 149, 150
]

class << self
	attr_accessor :_liquor_trans_keys
	private :_liquor_trans_keys, :_liquor_trans_keys=
end
self._liquor_trans_keys = [
	33, 37, 123, 95, 65, 90, 97, 122, 
	9, 32, 37, 125, 10, 92, 123, 10, 
	92, 123, 10, 92, 123, 10, 92, 33, 
	37, 123, 33, 123, 125, 33, 10, 34, 
	92, 34, 92, 10, 39, 92, 39, 92, 
	95, 48, 57, 65, 90, 97, 122, 48, 
	57, 9, 32, 95, 101, 65, 90, 97, 
	122, 9, 32, 58, 95, 48, 57, 65, 
	90, 97, 122, 58, 95, 110, 48, 57, 
	65, 90, 97, 122, 58, 95, 100, 48, 
	57, 65, 90, 97, 122, 32, 58, 95, 
	48, 57, 65, 90, 97, 122, 95, 48, 
	57, 65, 90, 97, 122, 9, 32, 33, 
	34, 37, 38, 39, 40, 41, 42, 43, 
	44, 45, 46, 47, 60, 61, 62, 91, 
	93, 95, 124, 125, 48, 57, 65, 90, 
	97, 122, 9, 32, 61, 125, 38, 61, 
	61, 61, 58, 95, 48, 57, 65, 90, 
	97, 122, 9, 32, 37, 124, 125, 0
]

class << self
	attr_accessor :_liquor_single_lengths
	private :_liquor_single_lengths, :_liquor_single_lengths=
end
self._liquor_single_lengths = [
	3, 1, 3, 1, 3, 3, 3, 2, 
	3, 2, 1, 1, 3, 2, 3, 2, 
	1, 0, 4, 2, 2, 3, 3, 3, 
	1, 23, 2, 1, 1, 1, 1, 1, 
	1, 2, 3, 1, 1
]

class << self
	attr_accessor :_liquor_range_lengths
	private :_liquor_range_lengths, :_liquor_range_lengths=
end
self._liquor_range_lengths = [
	0, 2, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	3, 1, 2, 0, 3, 3, 3, 3, 
	3, 3, 0, 0, 0, 0, 0, 0, 
	0, 3, 0, 0, 0
]

class << self
	attr_accessor :_liquor_index_offsets
	private :_liquor_index_offsets, :_liquor_index_offsets=
end
self._liquor_index_offsets = [
	0, 4, 8, 12, 14, 18, 22, 26, 
	29, 33, 36, 38, 40, 44, 47, 51, 
	54, 59, 61, 68, 71, 77, 84, 91, 
	98, 103, 130, 133, 135, 137, 139, 141, 
	143, 145, 151, 155, 157
]

class << self
	attr_accessor :_liquor_indicies
	private :_liquor_indicies, :_liquor_indicies=
end
self._liquor_indicies = [
	0, 0, 0, 1, 3, 3, 3, 2, 
	5, 5, 6, 4, 7, 4, 8, 9, 
	10, 1, 8, 9, 12, 1, 8, 9, 
	13, 1, 8, 9, 1, 15, 16, 17, 
	1, 19, 20, 18, 22, 21, 23, 21, 
	25, 26, 27, 24, 29, 30, 28, 32, 
	33, 34, 31, 36, 37, 35, 40, 39, 
	40, 40, 38, 39, 41, 43, 43, 44, 
	45, 44, 44, 42, 43, 43, 46, 48, 
	44, 44, 44, 44, 47, 48, 44, 49, 
	44, 44, 44, 47, 48, 44, 50, 44, 
	44, 44, 47, 51, 48, 44, 44, 44, 
	44, 47, 3, 3, 3, 3, 52, 54, 
	54, 55, 56, 57, 58, 59, 60, 61, 
	62, 63, 64, 65, 66, 67, 69, 70, 
	71, 73, 74, 72, 75, 76, 68, 72, 
	72, 53, 54, 54, 77, 79, 78, 81, 
	80, 83, 82, 85, 84, 87, 86, 89, 
	88, 91, 72, 72, 72, 72, 90, 5, 
	5, 6, 92, 94, 93, 95, 82, 0
]

class << self
	attr_accessor :_liquor_trans_targs
	private :_liquor_trans_targs, :_liquor_trans_targs=
end
self._liquor_trans_targs = [
	4, 5, 18, 24, 25, 2, 3, 25, 
	5, 6, 8, 4, 0, 7, 4, 4, 
	4, 4, 9, 10, 11, 9, 9, 9, 
	12, 12, 12, 13, 12, 12, 12, 14, 
	14, 14, 15, 14, 14, 14, 16, 17, 
	16, 16, 18, 19, 20, 21, 18, 18, 
	18, 22, 23, 1, 18, 25, 26, 27, 
	25, 28, 29, 25, 25, 25, 25, 25, 
	25, 25, 25, 25, 25, 30, 31, 32, 
	33, 25, 25, 35, 36, 25, 25, 25, 
	25, 25, 25, 25, 25, 25, 25, 25, 
	25, 25, 25, 34, 25, 25, 25, 25
]

class << self
	attr_accessor :_liquor_trans_actions
	private :_liquor_trans_actions, :_liquor_trans_actions=
end
self._liquor_trans_actions = [
	137, 7, 57, 0, 125, 0, 0, 61, 
	139, 0, 0, 133, 0, 0, 135, 131, 
	129, 127, 13, 0, 0, 15, 11, 9, 
	23, 25, 21, 0, 27, 17, 19, 35, 
	37, 33, 0, 39, 29, 31, 43, 0, 
	41, 45, 49, 0, 0, 0, 51, 55, 
	47, 0, 7, 0, 53, 103, 0, 0, 
	95, 0, 0, 97, 71, 73, 79, 75, 
	63, 77, 65, 81, 59, 0, 0, 0, 
	0, 67, 69, 0, 0, 105, 121, 85, 
	115, 101, 123, 91, 119, 89, 111, 83, 
	117, 87, 107, 142, 109, 113, 93, 99
]

class << self
	attr_accessor :_liquor_to_state_actions
	private :_liquor_to_state_actions, :_liquor_to_state_actions=
end
self._liquor_to_state_actions = [
	0, 0, 0, 0, 3, 0, 0, 0, 
	0, 3, 0, 0, 3, 0, 3, 0, 
	3, 0, 3, 0, 0, 0, 0, 0, 
	0, 3, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_from_state_actions
	private :_liquor_from_state_actions, :_liquor_from_state_actions=
end
self._liquor_from_state_actions = [
	0, 0, 0, 0, 5, 0, 0, 0, 
	0, 5, 0, 0, 5, 0, 5, 0, 
	5, 0, 5, 0, 0, 0, 0, 0, 
	0, 5, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_actions
	private :_liquor_eof_actions, :_liquor_eof_actions=
end
self._liquor_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 1, 0, 1, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_trans
	private :_liquor_eof_trans, :_liquor_eof_trans=
end
self._liquor_eof_trans = [
	1, 3, 5, 5, 0, 12, 12, 12, 
	15, 0, 22, 22, 0, 29, 0, 36, 
	0, 42, 0, 47, 48, 48, 48, 48, 
	53, 0, 78, 79, 81, 83, 85, 87, 
	89, 91, 93, 94, 83
]

class << self
	attr_accessor :liquor_start
end
self.liquor_start = 4;
class << self
	attr_accessor :liquor_first_final
end
self.liquor_first_final = 4;
class << self
	attr_accessor :liquor_error
end
self.liquor_error = -1;

class << self
	attr_accessor :liquor_en_comment
end
self.liquor_en_comment = 9;
class << self
	attr_accessor :liquor_en_dqstring
end
self.liquor_en_dqstring = 12;
class << self
	attr_accessor :liquor_en_sqstring
end
self.liquor_en_sqstring = 14;
class << self
	attr_accessor :liquor_en_integer
end
self.liquor_en_integer = 16;
class << self
	attr_accessor :liquor_en_tag_start
end
self.liquor_en_tag_start = 18;
class << self
	attr_accessor :liquor_en_code
end
self.liquor_en_code = 25;
class << self
	attr_accessor :liquor_en_plaintext
end
self.liquor_en_plaintext = 4;


# line 184 "lib/liquor/grammar/lexer.rl"

    def self.lex(data)
      eof    = data.length
      ts     = nil # token start
      te     = nil # token end
      stack  = []

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
      loc = ->(index) {
        line_start_index = find_line_start.(index)
        [ line_start_index, index - line_starts[line_start_index] ]
      }

      tokens = []

      fixtok = ->(new_type) {
        tokens.last[0] = new_type
      }
      tok = ->(type, data=nil, options={}) {
        sl, sc, el, ec = *loc.(options[:ts] || ts),
                         *loc.(options[:te] || te - 1)
        tokens << [type, { line: sl, start: sc, end: ec }, *data]
      }

      
# line 311 "lib/liquor/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = liquor_start
	top = 0
	ts = nil
	te = nil
	act = 0
end

# line 226 "lib/liquor/grammar/lexer.rl"
      
# line 324 "lib/liquor/lexer.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	end
	if _goto_level <= _resume
	_acts = _liquor_from_state_actions[cs]
	_nacts = _liquor_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _liquor_actions[_acts - 1]
			when 4 then
# line 1 "NONE"
		begin
ts = p
		end
# line 354 "lib/liquor/lexer.rb"
		end # from state action switch
	end
	if _trigger_goto
		next
	end
	_keys = _liquor_key_offsets[cs]
	_trans = _liquor_index_offsets[cs]
	_klen = _liquor_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _liquor_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _liquor_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _liquor_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _liquor_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _liquor_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	_trans = _liquor_indicies[_trans]
	end
	if _goto_level <= _eof_trans
	cs = _liquor_trans_targs[_trans]
	if _liquor_trans_actions[_trans] != 0
		_acts = _liquor_trans_actions[_trans]
		_nacts = _liquor_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _liquor_actions[_acts - 1]
when 0 then
# line 7 "lib/liquor/grammar/lexer.rl"
		begin
 line_starts.push(p + 1) 		end
when 2 then
# line 108 "lib/liquor/grammar/lexer.rl"
		begin
 kw_stop = p 		end
when 5 then
# line 1 "NONE"
		begin
te = p+1
		end
when 6 then
# line 40 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  	begin
		stack[top] = cs
		top+= 1
		cs = 9
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 7 then
# line 41 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  	begin
		top -= 1
		cs = stack[top]
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 8 then
# line 42 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
		end
when 9 then
# line 42 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 10 then
# line 46 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '"'  end
		end
when 11 then
# line 47 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 12 then
# line 23 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string, ts: str_start); 	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end

 end
		end
when 13 then
# line 19 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  string << data[p]
 end
		end
when 14 then
# line 27 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  runaway = true
 end
		end
when 15 then
# line 19 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin 
  string << data[p]
 end
		end
when 16 then
# line 55 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << "'"  end
		end
when 17 then
# line 56 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 18 then
# line 23 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string, ts: str_start); 	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end

 end
		end
when 19 then
# line 19 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  string << data[p]
 end
		end
when 20 then
# line 27 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  runaway = true
 end
		end
when 21 then
# line 19 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin 
  string << data[p]
 end
		end
when 22 then
# line 31 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
 end
		end
when 23 then
# line 66 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 24 then
# line 64 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:integer, data[ts...te].to_i)  end
		end
when 25 then
# line 92 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  fixtok.(:lblock2)
        tok.(:keyword, data[ts...te - 1])
        	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 26 then
# line 98 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 27 then
# line 70 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 28 then
# line 73 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts + 4...te]
        if tag_stack.last == tag
          fixtok.(:lblock2)
          tok.(:endtag)
          tag_stack.pop
        else
          tok.(:ident, data[ts...te])
        end
        	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 29 then
# line 85 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts...te]
        tok.(:ident, tag)
        last_tag = tag
        	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 30 then
# line 85 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tag = data[ts...te]
        tok.(:ident, tag)
        last_tag = tag
        	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 31 then
# line 106 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 16
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 32 then
# line 109 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:keyword, data[ts...kw_stop], te: kw_stop)
        tok.(:rblock,  nil,                ts: te - 2)
        if last_tag
          tag_stack.push last_tag
          last_tag = nil
        end
        	begin
		cs = 4
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 33 then
# line 124 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:comma)  end
		end
when 34 then
# line 125 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:dot)    end
		end
when 35 then
# line 127 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lbracket)  end
		end
when 36 then
# line 128 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rbracket)  end
		end
when 37 then
# line 130 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lparen)  end
		end
when 38 then
# line 131 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rparen)  end
		end
when 39 then
# line 135 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_plus)   end
		end
when 40 then
# line 136 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_minus)  end
		end
when 41 then
# line 137 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_mul)    end
		end
when 42 then
# line 138 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_div)    end
		end
when 43 then
# line 141 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_eq)   end
		end
when 44 then
# line 142 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_neq)  end
		end
when 45 then
# line 144 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_geq)  end
		end
when 46 then
# line 146 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_leq)  end
		end
when 47 then
# line 150 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_and)  end
		end
when 48 then
# line 151 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_or)  end
		end
when 49 then
# line 153 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  str_start = p; 	begin
		cs = 12
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 50 then
# line 154 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  str_start = p; 	begin
		cs = 14
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 51 then
# line 156 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rinterp); 	begin
		cs = 4
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 52 then
# line 157 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rblock);  	begin
		cs = 4
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 53 then
# line 31 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
 end
		end
when 54 then
# line 102 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 55 then
# line 104 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:ident, data[ts...te])  end
		end
when 56 then
# line 119 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:keyword, data[ts...te-1])  end
		end
when 57 then
# line 122 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:keyword, '=')  end
		end
when 58 then
# line 133 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:pipe)  end
		end
when 59 then
# line 139 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_mod)    end
		end
when 60 then
# line 143 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_gt)   end
		end
when 61 then
# line 145 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_lt)   end
		end
when 62 then
# line 148 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_not)  end
		end
when 63 then
# line 31 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin 
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
 end
		end
when 64 then
# line 119 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:keyword, data[ts...te-1])  end
		end
when 65 then
# line 167 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:linterp); 	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 66 then
# line 170 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lblock);  	begin
		cs = 18
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 67 then
# line 173 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  	begin
		stack[top] = cs
		top+= 1
		cs = 9
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 68 then
# line 164 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:plaintext, data[ts...te]);  end
		end
when 69 then
# line 176 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  p = p - 1; 	begin
		cs = 25
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 70 then
# line 164 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:plaintext, data[ts...te]);  end
		end
# line 1006 "lib/liquor/lexer.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	_acts = _liquor_to_state_actions[cs]
	_nacts = _liquor_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _liquor_actions[_acts - 1]
when 3 then
# line 1 "NONE"
		begin
ts = nil;		end
# line 1026 "lib/liquor/lexer.rb"
		end # to state action switch
	end
	if _trigger_goto
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _liquor_eof_trans[cs] > 0
		_trans = _liquor_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
	__acts = _liquor_eof_actions[cs]
	__nacts =  _liquor_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _liquor_actions[__acts - 1]
when 1 then
# line 27 "lib/liquor/grammar/lexer.rl"
		begin

  runaway = true
		end
# line 1058 "lib/liquor/lexer.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 227 "lib/liquor/grammar/lexer.rl"

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