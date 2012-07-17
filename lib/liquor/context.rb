require 'set'

module Liquor
  class Context
    include ASTTools

    attr_reader :compiler,  :emitter
    attr_reader :externals, :variables
    attr_reader :nesting

    RESERVED_NAMES = %w(_env _buf).freeze

    def initialize(compiler, externals)
      @compiler  = compiler
      @externals = externals

      @emitter   = Emitter.new(self)

      @variables = Set[]
      @mapping   = {}

      @nesting = 1

      @externals.each do |external|
        declare external
      end
    end

    def builtin?(name)
      %w(true false null).include? name
    end

    def function?(name)
      @compiler.has_function? name
    end

    def variable?(name)
      @variables.include? name
    end

    def allocated?(name)
      builtin?(name) || function?(name) || variable?(name)
    end

    def type(name)
      if builtin?(name)
        :builtin
      elsif function?(name)
        :function
      elsif variable?(name)
        :variable
      else
        :free
      end
    end

    def declare(name, loc=nil)
      if allocated?(name)
        raise NameError.new("variable name `#{name}' is already occupied by #{type name}", loc)
      end

      mapped, idx = name, 0
      while RESERVED_NAMES.include?(mapped) ||
            @mapping.include?(mapped)
        mapped = "#{name}_m#{idx}" # `m' stands for `mangled'
      end

      @variables.add name
      @mapping[mapped] = name
    end

    def access(name, loc=nil)
      if variable?(name)
        @mapping[name]
      else
        raise NameError.new("variable `#{name}' is undefined", loc)
      end
    end

    def compile_toplevel(block)
      compile_block(block)

      [
        %!lambda { |_env={}|\n!,
        %|  _buf = ""\n|,
        ([
          %|  |,
          @externals.map do |extern|
            access(extern)
          end.join(", "),
          %| = |,
          @externals.map do |extern|
            %Q|_env[#{extern.inspect}]|
          end.join(", "),
        ] if @externals.any?),
        %|\n|,
        @emitter.flush!,
        %|}\n|
      ].join
    end

    def compile_block(block)
      block.each do |node|
        case ntype(node)
        when :plaintext
          @emitter.cat! @emitter.string(node)

        when :interp
          expr, = nvalue(node)
          @emitter.cat! @emitter.check_string(expr)

        else
          raise "unknown block-level node #{ntype(node)}"
        end
      end
    end
  end
end