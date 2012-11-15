module Liquor
  class Error < StandardError
  end

  class SourceMappedError < Error
    attr_reader :location
    attr_reader :raw_message

    def initialize(message, location=nil)
      location_info = ""
      if location
        if location.include? :file
          location_info << "`#{location[:file]}'"
        end

        if location.include? :line
          location_info << ": line #{location[:line] + 1}"
          if location.include? :start
            location_info << ", column #{location[:start] + 1}"
          end
        end
      end

      @location    = location
      @raw_message = message

      if location_info.empty?
        super(message)
      else
        super("#{message} at #{location_info}")
      end
    end

    def decorate(source)
      if @location && @location.has_key?(:line)
        line = source.lines.drop(@location[:line]).first.rstrip

        if @location.has_key? :start
          start_col = tabify_column line, @location[:start]
          pointer =  "~" * start_col

          if location.has_key? :end
            end_col = tabify_column line, @location[:end]

            pointer += "^" * (end_col - start_col + 1)
          else
            pointer += "^"
          end
        end
      end

      [ line, pointer ].compact
    end

    # Dammit, why should I replicate parts of VT-52 all over again?!
    # Curse backwards compatibility and C.
    def tabify_column(line, column)
      display_column = 0

      line[0...column].each_char do |char|
        if char == "\t"
          display_column += 8 - (display_column % 8)
        else
          display_column += 1
        end
      end

      display_column
    end
  end

  class SyntaxError < SourceMappedError
  end

  class PartialError < SourceMappedError
  end

  class ArgumentError < SourceMappedError
  end

  class NameError < SourceMappedError
  end

  class TypeError < SourceMappedError
  end

  class ArgumentTypeError < SourceMappedError
    attr_reader :location

    def initialize(message, location=nil)
      location_info = ""
      if location
        if location.include? :function
          location_info << "function `#{location[:function]}'"
          if location.include? :argument
            if location[:argument].nil?
              location_info << ", unnamed argument"
            else
              location_info << ", argument `#{location[:argument]}'"
            end
          end
        end
      end

      if location_info.empty?
        super(message, location)
      else
        super("#{message} at #{location_info}", location)
      end
    end
  end

  class HostError < SourceMappedError
    attr_reader :original_error, :host_backtrace

    def initialize(message, original_error, host_backtrace, location=nil)
      @original_error = original_error
      @host_backtrace = host_backtrace

      super(message, location)
    end
  end
end