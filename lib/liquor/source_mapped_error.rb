module Liquor
  class SourceMappedError < StandardError
    def initialize(message, location={})
      location_info = ""
      if location.include? :line
        location_info << "line #{location[:line] + 1}"
        if location.include? :start
          location_info << ", column #{location[:start] + 1}"
        end
      end

      if location_info.empty?
        super(message)
      else
        super("#{message} at #{location_info}")
      end

      @location = location
    end

    def decorate(source)
      line = source.lines.drop(@location[:line]).first
      pointer =  "~" * (@location[:start])
      pointer += "^" * (@location[:end] - @location[:start] + 1)
      [ line, pointer ]
    end
  end
end