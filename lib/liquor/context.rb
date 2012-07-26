require 'set'

module Liquor
  class Context
    attr_reader :compiler,  :emitter
    attr_reader :externals, :variables
    attr_reader :nesting

    RESERVED_NAMES = %w(_env _buf _storage
      __LINE__ __FILE__ __ENCODING__ BEGIN END alias and begin
      break case class def do else elsif end ensure false for in
      module next nil not or redo rescue retry return self super
      then true undef when yield if unless while until).freeze

    def initialize(compiler, externals)
      @compiler  = compiler
      @externals = externals

      @emitter   = Emitter.new(self)

      @variables = Set[]
      @var_stack = []

      @mapping   = {}
      @map_stack = []

      @nesting   = 1

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
      name   = name.to_s

      if builtin?(name) || function?(name)
        raise NameError.new("identifier `#{name}' is already occupied by #{type name}", loc)
      end

      shadow = @var_stack.count > 0 && @var_stack[-1].include?(name)

      if !@variables.include?(name) || shadow
        mapped, idx = name, 0
        while RESERVED_NAMES.include?(mapped) ||
              @mapping.values.include?(mapped)
          mapped = "#{name}_m#{idx}" # `m' stands for `mangled'
        end

        @variables.add name
        @mapping[name] = mapped
      end
    end

    def access(name, loc=nil)
      name = name.to_s

      if variable?(name)
        @mapping[name]
      else
        raise NameError.new("variable `#{name}' is undefined", loc)
      end
    end

    def nest
      @var_stack.push @variables
      @variables = @variables.dup

      @map_stack.push @mapping
      @mapping = @mapping.dup

      @nesting  += 1

      yield
    ensure
      @variables = @var_stack.pop
      @mapping   = @map_stack.pop

      @nesting  -= 1
    end
  end
end