module Liquor
  class SyntaxError < StandardError
    def initialize(message, options={})
      position_info = ""
      if options.include? :line
        position_info << "line #{options[:line] + 1}"
        if options.include? :start
          position_info << ", column #{options[:start] + 1}"
        end
      end

      if position_info.empty?
        super(message)
      else
        super("#{message} at #{position_info}")
      end

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