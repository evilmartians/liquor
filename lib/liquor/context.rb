require 'set'

module Liquor
  class Context
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
      name = name.to_s

      if allocated?(name)
        raise NameError.new("identifier `#{name}' is already occupied by #{type name}", loc)
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
      name = name.to_s

      if variable?(name)
        @mapping[name]
      else
        raise NameError.new("variable `#{name}' is undefined", loc)
      end
    end
  end
end