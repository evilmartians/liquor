
# line 1 "lib/liquor/grammar/lexer.rl"

# line 153 "lib/liquor/grammar/lexer.rl"


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
	57, 1, 58, 1, 59, 1, 60, 2, 
	5, 0, 2, 5, 2
]

class << self
	attr_accessor :_liquor_key_offsets
	private :_liquor_key_offsets, :_liquor_key_offsets=
end
self._liquor_key_offsets = [
	0, 2, 5, 6, 9, 12, 15, 17, 
	19, 22, 24, 27, 29, 37, 39, 47, 
	56, 65, 73, 81, 110, 112, 113, 114, 
	115, 117, 118, 119, 120, 128, 131, 132
]

class << self
	attr_accessor :_liquor_trans_keys
	private :_liquor_trans_keys, :_liquor_trans_keys=
end
self._liquor_trans_keys = [
	37, 123, 9, 32, 37, 125, 10, 92, 
	123, 10, 92, 123, 10, 92, 123, 10, 
	92, 37, 123, 10, 34, 92, 34, 92, 
	10, 39, 92, 39, 92, 9, 32, 95, 
	101, 65, 90, 97, 122, 9, 32, 58, 
	95, 48, 57, 65, 90, 97, 122, 58, 
	95, 110, 48, 57, 65, 90, 97, 122, 
	58, 95, 100, 48, 57, 65, 90, 97, 
	122, 58, 95, 48, 57, 65, 90, 97, 
	122, 58, 95, 48, 57, 65, 90, 97, 
	122, 9, 32, 33, 34, 37, 38, 39, 
	40, 41, 42, 43, 44, 45, 46, 47, 
	60, 61, 62, 91, 93, 95, 124, 125, 
	48, 57, 65, 90, 97, 122, 9, 32, 
	61, 125, 38, 48, 57, 61, 61, 61, 
	58, 95, 48, 57, 65, 90, 97, 122, 
	9, 32, 37, 124, 125, 0
]

class << self
	attr_accessor :_liquor_single_lengths
	private :_liquor_single_lengths, :_liquor_single_lengths=
end
self._liquor_single_lengths = [
	2, 3, 1, 3, 3, 3, 2, 2, 
	3, 2, 3, 2, 4, 2, 2, 3, 
	3, 2, 2, 23, 2, 1, 1, 1, 
	0, 1, 1, 1, 2, 3, 1, 1
]

class << self
	attr_accessor :_liquor_range_lengths
	private :_liquor_range_lengths, :_liquor_range_lengths=
end
self._liquor_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 2, 0, 3, 3, 
	3, 3, 3, 3, 0, 0, 0, 0, 
	1, 0, 0, 0, 3, 0, 0, 0
]

class << self
	attr_accessor :_liquor_index_offsets
	private :_liquor_index_offsets, :_liquor_index_offsets=
end
self._liquor_index_offsets = [
	0, 3, 7, 9, 13, 17, 21, 24, 
	27, 31, 34, 38, 41, 48, 51, 57, 
	64, 71, 77, 83, 110, 113, 115, 117, 
	119, 121, 123, 125, 127, 133, 137, 139
]

class << self
	attr_accessor :_liquor_trans_targs
	private :_liquor_trans_targs, :_liquor_trans_targs=
end
self._liquor_trans_targs = [
	3, 3, 4, 1, 1, 2, 19, 19, 
	19, 4, 5, 7, 4, 4, 5, 0, 
	4, 4, 5, 6, 4, 4, 5, 4, 
	3, 3, 4, 8, 8, 9, 8, 8, 
	8, 8, 10, 10, 11, 10, 10, 10, 
	10, 13, 13, 14, 15, 14, 14, 12, 
	13, 13, 12, 12, 14, 14, 14, 14, 
	12, 12, 14, 16, 14, 14, 14, 12, 
	12, 14, 17, 14, 14, 14, 12, 12, 
	18, 14, 18, 18, 12, 12, 18, 18, 
	18, 18, 12, 20, 20, 21, 19, 22, 
	23, 19, 19, 19, 19, 19, 19, 19, 
	19, 19, 25, 26, 27, 19, 19, 28, 
	30, 31, 24, 28, 28, 19, 20, 20, 
	19, 19, 19, 19, 19, 19, 19, 24, 
	19, 19, 19, 19, 19, 19, 19, 29, 
	28, 28, 28, 28, 19, 1, 1, 2, 
	19, 19, 19, 19, 19, 3, 19, 19, 
	3, 3, 3, 3, 8, 10, 12, 12, 
	12, 12, 12, 12, 19, 19, 19, 19, 
	19, 19, 19, 19, 19, 19, 19, 19, 
	0
]

class << self
	attr_accessor :_liquor_trans_actions
	private :_liquor_trans_actions, :_liquor_trans_actions=
end
self._liquor_trans_actions = [
	117, 117, 7, 0, 0, 0, 107, 43, 
	107, 119, 0, 0, 7, 119, 0, 0, 
	7, 119, 0, 0, 7, 119, 0, 7, 
	111, 109, 7, 17, 13, 0, 15, 9, 
	11, 19, 29, 25, 0, 27, 21, 23, 
	31, 0, 0, 0, 0, 0, 0, 35, 
	0, 0, 37, 33, 0, 0, 0, 0, 
	41, 33, 0, 0, 0, 0, 0, 41, 
	33, 0, 0, 0, 0, 0, 41, 33, 
	0, 0, 0, 0, 41, 33, 0, 0, 
	0, 0, 39, 0, 0, 0, 77, 0, 
	0, 79, 53, 55, 61, 57, 45, 59, 
	47, 63, 0, 0, 0, 49, 51, 0, 
	0, 0, 0, 0, 0, 85, 0, 0, 
	87, 67, 103, 83, 97, 73, 105, 0, 
	91, 71, 101, 65, 105, 69, 99, 122, 
	0, 0, 0, 0, 89, 0, 0, 0, 
	93, 75, 95, 81, 105, 117, 107, 107, 
	113, 113, 113, 115, 19, 31, 37, 41, 
	41, 41, 41, 39, 87, 103, 97, 105, 
	91, 101, 105, 99, 89, 93, 95, 105, 
	0
]

class << self
	attr_accessor :_liquor_to_state_actions
	private :_liquor_to_state_actions, :_liquor_to_state_actions=
end
self._liquor_to_state_actions = [
	0, 0, 0, 3, 0, 0, 0, 0, 
	3, 0, 3, 0, 3, 0, 0, 0, 
	0, 0, 0, 3, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_from_state_actions
	private :_liquor_from_state_actions, :_liquor_from_state_actions=
end
self._liquor_from_state_actions = [
	0, 0, 0, 5, 0, 0, 0, 0, 
	5, 0, 5, 0, 5, 0, 0, 0, 
	0, 0, 0, 5, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_actions
	private :_liquor_eof_actions, :_liquor_eof_actions=
end
self._liquor_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 0, 1, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_trans
	private :_liquor_eof_trans, :_liquor_eof_trans=
end
self._liquor_eof_trans = [
	142, 144, 144, 0, 147, 147, 147, 148, 
	0, 149, 0, 150, 0, 151, 155, 155, 
	155, 155, 156, 0, 157, 158, 159, 168, 
	161, 162, 168, 164, 165, 166, 167, 168
]

class << self
	attr_accessor :liquor_start
end
self.liquor_start = 3;
class << self
	attr_accessor :liquor_first_final
end
self.liquor_first_final = 3;
class << self
	attr_accessor :liquor_error
end
self.liquor_error = -1;

class << self
	attr_accessor :liquor_en_dqstring
end
self.liquor_en_dqstring = 8;
class << self
	attr_accessor :liquor_en_sqstring
end
self.liquor_en_sqstring = 10;
class << self
	attr_accessor :liquor_en_tag_start
end
self.liquor_en_tag_start = 12;
class << self
	attr_accessor :liquor_en_code
end
self.liquor_en_code = 19;
class << self
	attr_accessor :liquor_en_plaintext
end
self.liquor_en_plaintext = 3;


# line 158 "lib/liquor/grammar/lexer.rl"

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

      tok = ->(type, data=nil, options={}) {
        sl, sc, el, ec = *pos.(options[:ts] || ts),
                         *pos.(options[:te] || te - 1)
        tokens << [type, { line: sl, start: sc, end: ec }, *data]
      }

      
# line 279 "lib/liquor/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = liquor_start
	ts = nil
	te = nil
	act = 0
end

# line 196 "lib/liquor/grammar/lexer.rl"
      
# line 291 "lib/liquor/lexer.rb"
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
# line 321 "lib/liquor/lexer.rb"
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
# line 83 "lib/liquor/grammar/lexer.rl"
		begin
 kw_stop = p 		end
when 5 then
# line 1 "NONE"
		begin
te = p+1
		end
when 6 then
# line 29 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '"'  end
		end
when 7 then
# line 30 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 8 then
# line 20 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string, ts: str_start); 	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end

 end
		end
when 9 then
# line 16 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  string << data[p]
 end
		end
when 10 then
# line 24 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  runaway = true
 end
		end
when 11 then
# line 16 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin 
  string << data[p]
 end
		end
when 12 then
# line 38 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << "'"  end
		end
when 13 then
# line 39 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 14 then
# line 20 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string, ts: str_start); 	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end

 end
		end
when 15 then
# line 16 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  string << data[p]
 end
		end
when 16 then
# line 24 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  runaway = true
 end
		end
when 17 then
# line 16 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin 
  string << data[p]
 end
		end
when 18 then
# line 68 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:kwarg, data[ts...te - 1])
        	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 19 then
# line 73 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 20 then
# line 47 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 21 then
# line 50 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts + 3...te]
        if tag_stack.last == tag
          tok.(:endtag)
          tag_stack.pop
        else
          tok.(:tag, data[ts...te])
        end
        	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 22 then
# line 61 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts...te]
        tok.(:tag, tag)
        last_tag = tag
        	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 23 then
# line 84 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:kwarg,  data[ts...kw_stop], te: kw_stop)
        tok.(:rblock, nil,                ts: te - 2)
        if last_tag
          tag_stack.push last_tag
          last_tag = nil
        end
        	begin
		cs = 3
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 24 then
# line 95 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:comma)  end
		end
when 25 then
# line 96 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:dot)    end
		end
when 26 then
# line 98 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lbracket)  end
		end
when 27 then
# line 99 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rbracket)  end
		end
when 28 then
# line 101 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lparen)  end
		end
when 29 then
# line 102 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rparen)  end
		end
when 30 then
# line 106 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_plus)   end
		end
when 31 then
# line 107 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_minus)  end
		end
when 32 then
# line 108 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_mul)    end
		end
when 33 then
# line 109 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_div)    end
		end
when 34 then
# line 112 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_eq)   end
		end
when 35 then
# line 113 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_neq)  end
		end
when 36 then
# line 115 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_geq)  end
		end
when 37 then
# line 117 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_leq)  end
		end
when 38 then
# line 121 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_and)  end
		end
when 39 then
# line 122 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_or)  end
		end
when 40 then
# line 124 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  str_start = p; 	begin
		cs = 8
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 41 then
# line 125 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  str_start = p; 	begin
		cs = 10
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 42 then
# line 127 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rinterp); 	begin
		cs = 3
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 43 then
# line 128 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rblock);  	begin
		cs = 3
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 44 then
# line 130 "lib/liquor/grammar/lexer.rl"
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
when 45 then
# line 77 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 46 then
# line 79 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:ident, data[ts...te])  end
		end
when 47 then
# line 81 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:integer, data[ts...te].to_i)  end
		end
when 48 then
# line 93 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:kwarg, data[ts...te-1])  end
		end
when 49 then
# line 104 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:pipe)  end
		end
when 50 then
# line 110 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_mod)    end
		end
when 51 then
# line 114 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_gt)   end
		end
when 52 then
# line 116 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_lt)   end
		end
when 53 then
# line 119 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_not)  end
		end
when 54 then
# line 130 "lib/liquor/grammar/lexer.rl"
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
when 55 then
# line 93 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:kwarg, data[ts...te-1])  end
		end
when 56 then
# line 144 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:linterp); 	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 57 then
# line 147 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lblock);  	begin
		cs = 12
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 58 then
# line 141 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:plaintext, data[ts...te]);  end
		end
when 59 then
# line 150 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  p = p - 1; 	begin
		cs = 19
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 60 then
# line 141 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:plaintext, data[ts...te]);  end
		end
# line 860 "lib/liquor/lexer.rb"
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
# line 880 "lib/liquor/lexer.rb"
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
# line 24 "lib/liquor/grammar/lexer.rl"
		begin

  runaway = true
		end
# line 912 "lib/liquor/lexer.rb"
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

# line 197 "lib/liquor/grammar/lexer.rl"

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