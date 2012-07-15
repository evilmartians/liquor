
# line 1 "lib/liquor/lexer.rl"

# line 140 "lib/liquor/lexer.rl"


module Liquor
  module Lexer
    
# line 11 "lib/liquor/lexer.rb"
class << self
	attr_accessor :_liquor_actions
	private :_liquor_actions, :_liquor_actions=
end
self._liquor_actions = [
	0, 1, 1, 1, 2, 1, 3, 1, 
	4, 1, 5, 1, 6, 1, 7, 1, 
	8, 1, 9, 1, 10, 1, 11, 1, 
	12, 1, 13, 1, 14, 1, 15, 1, 
	16, 1, 17, 1, 18, 1, 19, 1, 
	20, 1, 21, 1, 22, 1, 23, 1, 
	24, 1, 25, 1, 26, 1, 27, 1, 
	28, 1, 29, 1, 30, 1, 31, 1, 
	32, 1, 33, 1, 34, 1, 35, 1, 
	36, 1, 37, 1, 38, 1, 39, 1, 
	40, 1, 41, 1, 42, 1, 43, 1, 
	44, 1, 45, 1, 46, 1, 47, 1, 
	48, 1, 49, 1, 50, 1, 51, 1, 
	52, 1, 53, 1, 54, 1, 55, 2, 
	4, 0
]

class << self
	attr_accessor :_liquor_key_offsets
	private :_liquor_key_offsets, :_liquor_key_offsets=
end
self._liquor_key_offsets = [
	0, 2, 5, 8, 11, 13, 15, 18, 
	20, 23, 25, 33, 35, 43, 52, 61, 
	69, 77, 105, 107, 108, 109, 111, 112, 
	113, 114, 122
]

class << self
	attr_accessor :_liquor_trans_keys
	private :_liquor_trans_keys, :_liquor_trans_keys=
end
self._liquor_trans_keys = [
	37, 123, 10, 92, 123, 10, 92, 123, 
	10, 92, 123, 10, 92, 37, 123, 10, 
	34, 92, 34, 92, 10, 39, 92, 39, 
	92, 9, 32, 95, 101, 65, 90, 97, 
	122, 9, 32, 58, 95, 48, 57, 65, 
	90, 97, 122, 58, 95, 110, 48, 57, 
	65, 90, 97, 122, 58, 95, 100, 48, 
	57, 65, 90, 97, 122, 58, 95, 48, 
	57, 65, 90, 97, 122, 58, 95, 48, 
	57, 65, 90, 97, 122, 9, 32, 33, 
	34, 37, 39, 40, 41, 42, 43, 44, 
	45, 46, 47, 60, 61, 62, 91, 93, 
	95, 124, 125, 48, 57, 65, 90, 97, 
	122, 9, 32, 61, 125, 48, 57, 61, 
	61, 61, 58, 95, 48, 57, 65, 90, 
	97, 122, 125, 0
]

class << self
	attr_accessor :_liquor_single_lengths
	private :_liquor_single_lengths, :_liquor_single_lengths=
end
self._liquor_single_lengths = [
	2, 3, 3, 3, 2, 2, 3, 2, 
	3, 2, 4, 2, 2, 3, 3, 2, 
	2, 22, 2, 1, 1, 0, 1, 1, 
	1, 2, 1
]

class << self
	attr_accessor :_liquor_range_lengths
	private :_liquor_range_lengths, :_liquor_range_lengths=
end
self._liquor_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 2, 0, 3, 3, 3, 3, 
	3, 3, 0, 0, 0, 1, 0, 0, 
	0, 3, 0
]

class << self
	attr_accessor :_liquor_index_offsets
	private :_liquor_index_offsets, :_liquor_index_offsets=
end
self._liquor_index_offsets = [
	0, 3, 7, 11, 15, 18, 21, 25, 
	28, 32, 35, 42, 45, 51, 58, 65, 
	71, 77, 103, 106, 108, 110, 112, 114, 
	116, 118, 124
]

class << self
	attr_accessor :_liquor_trans_targs
	private :_liquor_trans_targs, :_liquor_trans_targs=
end
self._liquor_trans_targs = [
	1, 1, 2, 2, 3, 5, 2, 2, 
	3, 0, 2, 2, 3, 4, 2, 2, 
	3, 2, 1, 1, 2, 6, 6, 7, 
	6, 6, 6, 6, 8, 8, 9, 8, 
	8, 8, 8, 11, 11, 12, 13, 12, 
	12, 10, 11, 11, 10, 10, 12, 12, 
	12, 12, 10, 10, 12, 14, 12, 12, 
	12, 10, 10, 12, 15, 12, 12, 12, 
	10, 10, 16, 12, 16, 16, 10, 10, 
	16, 16, 16, 16, 10, 18, 18, 19, 
	17, 20, 17, 17, 17, 17, 17, 17, 
	17, 17, 17, 22, 23, 24, 17, 17, 
	25, 17, 26, 21, 25, 25, 17, 18, 
	18, 17, 17, 17, 17, 17, 21, 17, 
	17, 17, 17, 17, 17, 17, 17, 25, 
	25, 25, 25, 17, 17, 17, 1, 1, 
	1, 1, 1, 6, 8, 10, 10, 10, 
	10, 10, 10, 17, 17, 17, 17, 17, 
	17, 17, 17, 17, 0
]

class << self
	attr_accessor :_liquor_trans_actions
	private :_liquor_trans_actions, :_liquor_trans_actions=
end
self._liquor_trans_actions = [
	109, 109, 7, 111, 0, 0, 7, 111, 
	0, 0, 7, 111, 0, 0, 7, 111, 
	0, 7, 103, 101, 7, 17, 13, 0, 
	15, 9, 11, 19, 29, 25, 0, 27, 
	21, 23, 31, 0, 0, 0, 0, 0, 
	0, 35, 0, 0, 37, 33, 0, 0, 
	0, 0, 41, 33, 0, 0, 0, 0, 
	0, 41, 33, 0, 0, 0, 0, 0, 
	41, 33, 0, 0, 0, 0, 41, 33, 
	0, 0, 0, 0, 39, 0, 0, 0, 
	75, 0, 77, 53, 55, 63, 59, 45, 
	61, 47, 65, 0, 0, 0, 49, 51, 
	0, 57, 0, 0, 0, 0, 83, 0, 
	0, 85, 69, 97, 81, 91, 0, 89, 
	73, 95, 67, 99, 71, 93, 43, 0, 
	0, 0, 0, 87, 79, 99, 109, 105, 
	105, 105, 107, 19, 31, 37, 41, 41, 
	41, 41, 39, 85, 97, 91, 89, 95, 
	99, 93, 87, 99, 0
]

class << self
	attr_accessor :_liquor_to_state_actions
	private :_liquor_to_state_actions, :_liquor_to_state_actions=
end
self._liquor_to_state_actions = [
	0, 3, 0, 0, 0, 0, 3, 0, 
	3, 0, 3, 0, 0, 0, 0, 0, 
	0, 3, 0, 0, 0, 0, 0, 0, 
	0, 0, 0
]

class << self
	attr_accessor :_liquor_from_state_actions
	private :_liquor_from_state_actions, :_liquor_from_state_actions=
end
self._liquor_from_state_actions = [
	0, 5, 0, 0, 0, 0, 5, 0, 
	5, 0, 5, 0, 0, 0, 0, 0, 
	0, 5, 0, 0, 0, 0, 0, 0, 
	0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_actions
	private :_liquor_eof_actions, :_liquor_eof_actions=
end
self._liquor_eof_actions = [
	0, 0, 0, 0, 0, 0, 1, 0, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_trans
	private :_liquor_eof_trans, :_liquor_eof_trans=
end
self._liquor_eof_trans = [
	127, 0, 130, 130, 130, 131, 0, 132, 
	0, 133, 0, 134, 138, 138, 138, 138, 
	139, 0, 140, 141, 142, 143, 144, 148, 
	146, 147, 148
]

class << self
	attr_accessor :liquor_start
end
self.liquor_start = 1;
class << self
	attr_accessor :liquor_first_final
end
self.liquor_first_final = 1;
class << self
	attr_accessor :liquor_error
end
self.liquor_error = -1;

class << self
	attr_accessor :liquor_en_dqstring
end
self.liquor_en_dqstring = 6;
class << self
	attr_accessor :liquor_en_sqstring
end
self.liquor_en_sqstring = 8;
class << self
	attr_accessor :liquor_en_tag_start
end
self.liquor_en_tag_start = 10;
class << self
	attr_accessor :liquor_en_code
end
self.liquor_en_code = 17;
class << self
	attr_accessor :liquor_en_plaintext
end
self.liquor_en_plaintext = 1;


# line 145 "lib/liquor/lexer.rl"

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
        [ line_start_index, index - line_starts[line_start_index] ]
      }

      tokens = []

      tok = ->(type, *data) {
        sl, sc, el, ec = *pos.(ts), *pos.(te - 1)
        tokens << [type, { line: sl, start: sc, end: ec }, *data]
      }

      
# line 267 "lib/liquor/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = liquor_start
	ts = nil
	te = nil
	act = 0
end

# line 179 "lib/liquor/lexer.rl"
      
# line 279 "lib/liquor/lexer.rb"
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
			when 3 then
# line 1 "NONE"
		begin
ts = p
		end
# line 309 "lib/liquor/lexer.rb"
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
# line 7 "lib/liquor/lexer.rl"
		begin
 line_starts.push(p + 1) 		end
when 4 then
# line 1 "NONE"
		begin
te = p+1
		end
when 5 then
# line 29 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  string << '"'  end
		end
when 6 then
# line 30 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 7 then
# line 20 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string); 	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end

 end
		end
when 8 then
# line 16 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
  string << data[p]
 end
		end
when 9 then
# line 24 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
  runaway = true
 end
		end
when 10 then
# line 16 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin 
  string << data[p]
 end
		end
when 11 then
# line 38 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  string << "'"  end
		end
when 12 then
# line 39 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 13 then
# line 20 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string); 	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end

 end
		end
when 14 then
# line 16 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
  string << data[p]
 end
		end
when 15 then
# line 24 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
  runaway = true
 end
		end
when 16 then
# line 16 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin 
  string << data[p]
 end
		end
when 17 then
# line 68 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:kwarg, data[ts...te - 1])
        	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 18 then
# line 73 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 19 then
# line 47 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1;		end
when 20 then
# line 50 "lib/liquor/lexer.rl"
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
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 21 then
# line 61 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts...te]
        tok.(:tag, tag)
        tag_stack.push tag
        	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 22 then
# line 83 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:kwarg, data[ts...te-1])  end
		end
when 23 then
# line 85 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:comma)  end
		end
when 24 then
# line 86 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:dot)    end
		end
when 25 then
# line 88 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:lbracket)  end
		end
when 26 then
# line 89 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:rbracket)  end
		end
when 27 then
# line 91 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:lparen)  end
		end
when 28 then
# line 92 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:rparen)  end
		end
when 29 then
# line 94 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:pipe)  end
		end
when 30 then
# line 96 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_plus)   end
		end
when 31 then
# line 97 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_minus)  end
		end
when 32 then
# line 98 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_mul)    end
		end
when 33 then
# line 99 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_div)    end
		end
when 34 then
# line 102 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_eq)   end
		end
when 35 then
# line 103 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_neq)  end
		end
when 36 then
# line 105 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_gte)  end
		end
when 37 then
# line 107 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_lte)  end
		end
when 38 then
# line 111 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  lit_start = p; 	begin
		cs = 6
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 39 then
# line 112 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  lit_start = p; 	begin
		cs = 8
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 40 then
# line 114 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:rinterp); 	begin
		cs = 1
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 41 then
# line 115 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:rblock);  	begin
		cs = 1
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 42 then
# line 117 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin 
      error = SyntaxError.new("unexpected #{data[p].inspect}",
        line:  line_starts.count - 1,
        start: p - line_starts.last,
        end:   p - line_starts.last)
      raise error
     end
		end
when 43 then
# line 77 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1;		end
when 44 then
# line 79 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:ident, data[ts...te])  end
		end
when 45 then
# line 81 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:integer, data[ts...te].to_i)  end
		end
when 46 then
# line 100 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_mod)    end
		end
when 47 then
# line 104 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_gt)   end
		end
when 48 then
# line 106 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_lt)   end
		end
when 49 then
# line 109 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_not)  end
		end
when 50 then
# line 117 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin 
      error = SyntaxError.new("unexpected #{data[p].inspect}",
        line:  line_starts.count - 1,
        start: p - line_starts.last,
        end:   p - line_starts.last)
      raise error
     end
		end
when 51 then
# line 131 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:linterp); 	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 52 then
# line 134 "lib/liquor/lexer.rl"
		begin
te = p+1
 begin  tok.(:lblock);  	begin
		cs = 10
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 53 then
# line 128 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:plaintext, data[ts...te]);  end
		end
when 54 then
# line 137 "lib/liquor/lexer.rl"
		begin
te = p
p = p - 1; begin  p = p - 1; 	begin
		cs = 17
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 55 then
# line 128 "lib/liquor/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:plaintext, data[ts...te]);  end
		end
# line 808 "lib/liquor/lexer.rb"
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
when 2 then
# line 1 "NONE"
		begin
ts = nil;		end
# line 828 "lib/liquor/lexer.rb"
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
# line 24 "lib/liquor/lexer.rl"
		begin

  runaway = true
		end
# line 860 "lib/liquor/lexer.rb"
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

# line 180 "lib/liquor/lexer.rl"

      if runaway
        line_start_index = find_line_start.(lit_start)
        line_start = line_starts[line_start_index]

        error = SyntaxError.new("literal not terminated",
          line:  line_start_index,
          start: lit_start - line_start,
          end:   lit_start - line_start)
        raise error
      end

      tokens
    end
  end
end