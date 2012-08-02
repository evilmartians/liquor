
# line 1 "lib/liquor/grammar/lexer.rl"

# line 212 "lib/liquor/grammar/lexer.rl"


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
	69, 1, 70, 1, 71, 1, 72, 2, 
	5, 0, 2, 5, 2
]

class << self
	attr_accessor :_liquor_key_offsets
	private :_liquor_key_offsets, :_liquor_key_offsets=
end
self._liquor_key_offsets = [
	0, 3, 8, 11, 12, 15, 16, 19, 
	22, 25, 27, 30, 32, 33, 34, 37, 
	39, 42, 44, 51, 53, 61, 63, 71, 
	80, 89, 98, 105, 134, 136, 137, 138, 
	139, 140, 144, 145, 153, 156, 157
]

class << self
	attr_accessor :_liquor_trans_keys
	private :_liquor_trans_keys, :_liquor_trans_keys=
end
self._liquor_trans_keys = [
	33, 37, 123, 95, 65, 90, 97, 122, 
	9, 32, 37, 125, 9, 32, 37, 125, 
	10, 92, 123, 10, 92, 123, 10, 92, 
	123, 10, 92, 33, 37, 123, 33, 123, 
	125, 33, 10, 34, 92, 34, 92, 10, 
	39, 92, 39, 92, 95, 48, 57, 65, 
	90, 97, 122, 48, 57, 9, 32, 95, 
	101, 65, 90, 97, 122, 9, 32, 58, 
	95, 48, 57, 65, 90, 97, 122, 58, 
	95, 110, 48, 57, 65, 90, 97, 122, 
	58, 95, 100, 48, 57, 65, 90, 97, 
	122, 32, 58, 95, 48, 57, 65, 90, 
	97, 122, 95, 48, 57, 65, 90, 97, 
	122, 9, 32, 33, 34, 37, 38, 39, 
	40, 41, 42, 43, 44, 45, 46, 47, 
	60, 61, 62, 91, 93, 95, 124, 125, 
	48, 57, 65, 90, 97, 122, 9, 32, 
	61, 125, 38, 61, 9, 32, 37, 61, 
	61, 58, 95, 48, 57, 65, 90, 97, 
	122, 9, 32, 37, 124, 125, 0
]

class << self
	attr_accessor :_liquor_single_lengths
	private :_liquor_single_lengths, :_liquor_single_lengths=
end
self._liquor_single_lengths = [
	3, 1, 3, 1, 3, 1, 3, 3, 
	3, 2, 3, 2, 1, 1, 3, 2, 
	3, 2, 1, 0, 4, 2, 2, 3, 
	3, 3, 1, 23, 2, 1, 1, 1, 
	1, 4, 1, 2, 3, 1, 1
]

class << self
	attr_accessor :_liquor_range_lengths
	private :_liquor_range_lengths, :_liquor_range_lengths=
end
self._liquor_range_lengths = [
	0, 2, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 3, 1, 2, 0, 3, 3, 
	3, 3, 3, 3, 0, 0, 0, 0, 
	0, 0, 0, 3, 0, 0, 0
]

class << self
	attr_accessor :_liquor_index_offsets
	private :_liquor_index_offsets, :_liquor_index_offsets=
end
self._liquor_index_offsets = [
	0, 4, 8, 12, 14, 18, 20, 24, 
	28, 32, 35, 39, 42, 44, 46, 50, 
	53, 57, 60, 65, 67, 74, 77, 83, 
	90, 97, 104, 109, 136, 139, 141, 143, 
	145, 147, 152, 154, 160, 164, 166
]

class << self
	attr_accessor :_liquor_indicies
	private :_liquor_indicies, :_liquor_indicies=
end
self._liquor_indicies = [
	0, 0, 0, 1, 3, 3, 3, 2, 
	5, 5, 6, 4, 7, 4, 9, 9, 
	10, 8, 11, 8, 12, 13, 14, 1, 
	12, 13, 16, 1, 12, 13, 17, 1, 
	12, 13, 1, 19, 20, 21, 1, 23, 
	24, 22, 26, 25, 27, 25, 29, 30, 
	31, 28, 33, 34, 32, 36, 37, 38, 
	35, 40, 41, 39, 44, 43, 44, 44, 
	42, 43, 45, 47, 47, 48, 49, 48, 
	48, 46, 47, 47, 50, 52, 48, 48, 
	48, 48, 51, 52, 48, 53, 48, 48, 
	48, 51, 52, 48, 54, 48, 48, 48, 
	51, 55, 52, 48, 48, 48, 48, 51, 
	3, 3, 3, 3, 56, 58, 58, 59, 
	60, 61, 62, 63, 64, 65, 66, 67, 
	68, 69, 70, 71, 73, 74, 75, 77, 
	78, 76, 79, 80, 72, 76, 76, 57, 
	58, 58, 81, 83, 82, 85, 84, 87, 
	86, 89, 88, 5, 5, 6, 91, 90, 
	93, 92, 95, 76, 76, 76, 76, 94, 
	9, 9, 10, 96, 98, 97, 99, 86, 
	0
]

class << self
	attr_accessor :_liquor_trans_targs
	private :_liquor_trans_targs, :_liquor_trans_targs=
end
self._liquor_trans_targs = [
	6, 7, 20, 26, 27, 2, 3, 27, 
	27, 4, 5, 27, 7, 8, 10, 6, 
	0, 9, 6, 6, 6, 6, 11, 12, 
	13, 11, 11, 11, 14, 14, 14, 15, 
	14, 14, 14, 16, 16, 16, 17, 16, 
	16, 16, 18, 19, 18, 18, 20, 21, 
	22, 23, 20, 20, 20, 24, 25, 1, 
	20, 27, 28, 29, 27, 30, 31, 27, 
	27, 27, 27, 27, 27, 27, 27, 27, 
	27, 32, 33, 34, 35, 27, 27, 37, 
	38, 27, 27, 27, 27, 27, 27, 27, 
	27, 27, 27, 27, 27, 27, 27, 36, 
	27, 27, 27, 27
]

class << self
	attr_accessor :_liquor_trans_actions
	private :_liquor_trans_actions, :_liquor_trans_actions=
end
self._liquor_trans_actions = [
	141, 7, 57, 0, 129, 0, 0, 63, 
	127, 0, 0, 61, 143, 0, 0, 137, 
	0, 0, 139, 135, 133, 131, 13, 0, 
	0, 15, 11, 9, 23, 25, 21, 0, 
	27, 17, 19, 35, 37, 33, 0, 39, 
	29, 31, 43, 0, 41, 45, 49, 0, 
	0, 0, 51, 55, 47, 0, 7, 0, 
	53, 105, 0, 0, 97, 0, 0, 99, 
	73, 75, 81, 77, 65, 79, 67, 83, 
	59, 0, 7, 0, 0, 69, 71, 0, 
	0, 107, 123, 87, 117, 103, 125, 93, 
	121, 91, 113, 85, 119, 89, 109, 146, 
	111, 115, 95, 101
]

class << self
	attr_accessor :_liquor_to_state_actions
	private :_liquor_to_state_actions, :_liquor_to_state_actions=
end
self._liquor_to_state_actions = [
	0, 0, 0, 0, 0, 0, 3, 0, 
	0, 0, 0, 3, 0, 0, 3, 0, 
	3, 0, 3, 0, 3, 0, 0, 0, 
	0, 0, 0, 3, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_from_state_actions
	private :_liquor_from_state_actions, :_liquor_from_state_actions=
end
self._liquor_from_state_actions = [
	0, 0, 0, 0, 0, 0, 5, 0, 
	0, 0, 0, 5, 0, 0, 5, 0, 
	5, 0, 5, 0, 5, 0, 0, 0, 
	0, 0, 0, 5, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_actions
	private :_liquor_eof_actions, :_liquor_eof_actions=
end
self._liquor_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 0, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0
]

class << self
	attr_accessor :_liquor_eof_trans
	private :_liquor_eof_trans, :_liquor_eof_trans=
end
self._liquor_eof_trans = [
	1, 3, 5, 5, 9, 9, 0, 16, 
	16, 16, 19, 0, 26, 26, 0, 33, 
	0, 40, 0, 46, 0, 51, 52, 52, 
	52, 52, 57, 0, 82, 83, 85, 87, 
	89, 91, 93, 95, 97, 98, 87
]

class << self
	attr_accessor :liquor_start
end
self.liquor_start = 6;
class << self
	attr_accessor :liquor_first_final
end
self.liquor_first_final = 6;
class << self
	attr_accessor :liquor_error
end
self.liquor_error = -1;

class << self
	attr_accessor :liquor_en_comment
end
self.liquor_en_comment = 11;
class << self
	attr_accessor :liquor_en_dqstring
end
self.liquor_en_dqstring = 14;
class << self
	attr_accessor :liquor_en_sqstring
end
self.liquor_en_sqstring = 16;
class << self
	attr_accessor :liquor_en_integer
end
self.liquor_en_integer = 18;
class << self
	attr_accessor :liquor_en_tag_start
end
self.liquor_en_tag_start = 20;
class << self
	attr_accessor :liquor_en_code
end
self.liquor_en_code = 27;
class << self
	attr_accessor :liquor_en_plaintext
end
self.liquor_en_plaintext = 6;


# line 217 "lib/liquor/grammar/lexer.rl"

    def self.lex(data, name='(code)', registered_tags={})
      eof    = data.length
      ts     = nil # token start
      te     = nil # token end
      stack  = []

      # Strings
      string    = ""
      str_start = nil
      runaway   = false

      # Tags
      tag_stack  = []
      tag_conts  = []
      last_tag   = nil
      kw_stop    = nil

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
        tokens << [type, { file: name, line: sl, start: sc, end: ec }, *data]
      }

      
# line 317 "lib/liquor/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = liquor_start
	top = 0
	ts = nil
	te = nil
	act = 0
end

# line 260 "lib/liquor/grammar/lexer.rl"
      
# line 330 "lib/liquor/lexer.rb"
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
# line 360 "lib/liquor/lexer.rb"
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
# line 130 "lib/liquor/grammar/lexer.rl"
		begin
 kw_stop = p 		end
when 5 then
# line 1 "NONE"
		begin
te = p+1
		end
when 6 then
# line 43 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 7 then
# line 44 "lib/liquor/grammar/lexer.rl"
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
# line 45 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
		end
when 9 then
# line 45 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 10 then
# line 49 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '"'  end
		end
when 11 then
# line 50 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 12 then
# line 23 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string.dup, ts: str_start)
  string.clear
  	begin
		cs = 27
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
# line 29 "lib/liquor/grammar/lexer.rl"
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
# line 58 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << "'"  end
		end
when 17 then
# line 59 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  string << '\\'  end
		end
when 18 then
# line 23 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  tok.(:string, string.dup, ts: str_start)
  string.clear
  	begin
		cs = 27
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
# line 29 "lib/liquor/grammar/lexer.rl"
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
# line 33 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    file:  name,
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
 end
		end
when 23 then
# line 69 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 24 then
# line 67 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:integer, data[ts...te].to_i)  end
		end
when 25 then
# line 114 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  fixtok.(:lblock2)
        tok.(:keyword, data[ts...te - 1])
        	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 26 then
# line 120 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 27 then
# line 73 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 28 then
# line 76 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts + 4...te]
        if tag_stack.last == tag
          fixtok.(:lblock2)
          tok.(:endtag)
          tag_stack.pop
          if registered_tags.include?(tag_stack.last)
            tag_conts = registered_tags[tag_stack.last].continuations
          end
        else
          (sl, sc), (el, ec) = loc.(ts), loc.(te)
          info = { file: name, line: sl, start: sc, end: ec }
          if tag_stack.any?
            raise SyntaxError.new("unmatched `end #{tag}', expected `end #{tag_stack.last}'", info)
          else
            raise SyntaxError.new("unexpected `end #{tag}'", info)
          end
        end
        	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 29 then
# line 97 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tag = data[ts...te]

        if tag_conts.include? tag
          fixtok.(:lblock2)
          tok.(:keyword, tag)
          	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end

        elsif registered_tags.include?(tag)
          tag_conts = registered_tags[tag].continuations
        end

        tok.(:ident, tag)
        last_tag = tag

        	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 30 then
# line 97 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tag = data[ts...te]

        if tag_conts.include? tag
          fixtok.(:lblock2)
          tok.(:keyword, tag)
          	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end

        elsif registered_tags.include?(tag)
          tag_conts = registered_tags[tag].continuations
        end

        tok.(:ident, tag)
        last_tag = tag

        	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 31 then
# line 128 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  p = p - 1; 	begin
		cs = 18
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 32 then
# line 131 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:keyword, data[ts...kw_stop], te: kw_stop)
        tok.(:rblock,  nil,                ts: te - 2)
        if last_tag
          tag_stack.push last_tag
          last_tag = nil
        end
        	begin
		cs = 6
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 33 then
# line 144 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
        tok.(:keyword, '=', te: ts + 1)
        tok.(:rblock,  nil, ts: te - 2)
        if last_tag
          tag_stack.push last_tag
          last_tag = nil
        end
        	begin
		cs = 6
		_trigger_goto = true
		_goto_level = _again
		break
	end

       end
		end
when 34 then
# line 157 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:comma)  end
		end
when 35 then
# line 158 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:dot)    end
		end
when 36 then
# line 160 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lbracket)  end
		end
when 37 then
# line 161 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rbracket)  end
		end
when 38 then
# line 163 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lparen)  end
		end
when 39 then
# line 164 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rparen)  end
		end
when 40 then
# line 168 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_plus)   end
		end
when 41 then
# line 169 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_minus)  end
		end
when 42 then
# line 170 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_mul)    end
		end
when 43 then
# line 171 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_div)    end
		end
when 44 then
# line 174 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_eq)   end
		end
when 45 then
# line 175 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_neq)  end
		end
when 46 then
# line 177 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_geq)  end
		end
when 47 then
# line 179 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_leq)  end
		end
when 48 then
# line 183 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_and)  end
		end
when 49 then
# line 184 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:op_or)  end
		end
when 50 then
# line 186 "lib/liquor/grammar/lexer.rl"
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
# line 187 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  str_start = p; 	begin
		cs = 16
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 52 then
# line 189 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rinterp); 	begin
		cs = 6
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 53 then
# line 190 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:rblock);  	begin
		cs = 6
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 54 then
# line 33 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin 
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    file:  name,
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
 end
		end
when 55 then
# line 124 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1;		end
when 56 then
# line 126 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:ident, data[ts...te])  end
		end
when 57 then
# line 141 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:keyword, data[ts...te-1])  end
		end
when 58 then
# line 155 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:keyword, '=')  end
		end
when 59 then
# line 166 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:pipe)  end
		end
when 60 then
# line 172 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_mod)    end
		end
when 61 then
# line 176 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_gt)   end
		end
when 62 then
# line 178 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_lt)   end
		end
when 63 then
# line 181 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:op_not)  end
		end
when 64 then
# line 33 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin 
  error = SyntaxError.new("unexpected `#{data[p].inspect[1..-2]}'",
    file:  name,
    line:  line_starts.count - 1,
    start: p - line_starts.last,
    end:   p - line_starts.last)
  raise error
 end
		end
when 65 then
# line 141 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:keyword, data[ts...te-1])  end
		end
when 66 then
# line 155 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:keyword, '=')  end
		end
when 67 then
# line 200 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:linterp); 	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 68 then
# line 203 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  tok.(:lblock);  	begin
		cs = 20
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 69 then
# line 206 "lib/liquor/grammar/lexer.rl"
		begin
te = p+1
 begin  	begin
		stack[top] = cs
		top+= 1
		cs = 11
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 70 then
# line 197 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  tok.(:plaintext, data[ts...te]);  end
		end
when 71 then
# line 209 "lib/liquor/grammar/lexer.rl"
		begin
te = p
p = p - 1; begin  p = p - 1; 	begin
		cs = 27
		_trigger_goto = true
		_goto_level = _again
		break
	end
  end
		end
when 72 then
# line 197 "lib/liquor/grammar/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  tok.(:plaintext, data[ts...te]);  end
		end
# line 1086 "lib/liquor/lexer.rb"
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
# line 1106 "lib/liquor/lexer.rb"
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
# line 29 "lib/liquor/grammar/lexer.rl"
		begin

  runaway = true
		end
# line 1138 "lib/liquor/lexer.rb"
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

# line 261 "lib/liquor/grammar/lexer.rl"

      if runaway
        line_start_index = find_line_start.(str_start)
        line_start = line_starts[line_start_index]

        error = SyntaxError.new("literal not terminated",
          file:  name,
          line:  line_start_index,
          start: str_start - line_start,
          end:   str_start - line_start)
        raise error
      end

      tokens
    end
  end
end