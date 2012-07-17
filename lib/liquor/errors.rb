module Liquor
  class SourceMappedError < StandardError
    def initialize(message, location=nil)
      location_info = ""
      if location
        if location.include? :line
          location_info << "line #{location[:line] + 1}"
          if location.include? :start
            location_info << ", column #{location[:start] + 1}"
          end
        end
      end

      @location = location

      if location_info.empty?
        super(message)
      else
        super("#{message} at #{location_info}")
      end
    end

    def decorate(source)
      if @location
        line = source.lines.drop(@location[:line]).first
        pointer =  "~" * (@location[:start])
        pointer += "^" * (@location[:end] - @location[:start] + 1)
        [ line, pointer ]
      end
    end
  end

  class SyntaxError < SourceMappedError
  end

  class ArgumentError < SourceMappedError
  end

  class NameError < SourceMappedError
  end
end