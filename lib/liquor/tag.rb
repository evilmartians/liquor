module Liquor
  class Tag
    include ASTTools

    attr_reader :name

    def initialize(name, &block)
      @name = name.to_s
      @body = block

      if @body.nil?
        raise "Cannot define a tag without body"
      end
    end

    def compile(emit, node)
      instance_exec emit, emit.context, node, &@body
    end
  end
end