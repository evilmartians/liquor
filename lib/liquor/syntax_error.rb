module Liquor
  class SyntaxError < StandardError
    def initialize(message, options={})
      super("#{message} at line #{options[:line] + 1}, column #{options[:start] + 1}")
      @options = options
    end

    def decorate(source)
      line = source.lines.drop(@options[:line]).first
      pointer =  "~" * (@options[:start])
      pointer += "^" * (@options[:end] - @options[:start] + 1)
      [ line, pointer ]
    end
  end
end