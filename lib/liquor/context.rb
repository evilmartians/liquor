module Liquor
  class Context
    attr_reader :externals, :variables
    attr_reader :nesting

    RESERVED_NAMES = %w(_env _buf).freeze

    def initialize(externals)
      @externals, @variables = externals, externals.dup
      @nesting = 1
    end

    def access(var_name)
      var_name # TODO
    end
  end
end