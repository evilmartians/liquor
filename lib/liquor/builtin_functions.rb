require 'time'
require 'uri'
require 'liquor/html_truncater'

module Liquor
  module Builtins
    #
    # Universal functions
    #

    function "is_empty", unnamed_arg: :any do |arg,|
      arg.nil? || (arg.respond_to?(:size) && arg.size == 0)
    end

    function "size", unnamed_arg: [:string, :tuple] do |arg,|
      arg.size
    end

    #
    # Type conversion functions
    #

    function "strftime",
              unnamed_arg: :string,
              mandatory_named_args: { format: :string } do |arg, kw|
      begin
        time = Time.parse(arg)

        if defined?(I18n)
          I18n.localize(time, format: kw[:format])
        else
          time.strftime(kw[:format])
        end

      rescue Exception => e
        arg
      end
    end

    function "to_number", unnamed_arg: [:integer, :string] do |arg,|
      if arg.is_a? Integer
        arg
      else
        arg.to_i
      end
    end

    #
    # Integer functions
    #

    function "is_even", unnamed_arg: :integer do |arg,|
      (arg % 2) == 0
    end

    function "is_odd", unnamed_arg: :integer do |arg,|
      (arg % 2) == 1
    end

    #
    # String functions
    #

    function "downcase", unnamed_arg: :string do |arg,|
      arg.downcase
    end

    function "upcase", unnamed_arg: :string do |arg,|
      arg.upcase
    end

    function "capitalize", unnamed_arg: :string do |arg,|
      arg.capitalize
    end

    function "starts_with", unnamed_arg: :string,
                            mandatory_named_args: { pattern: :string } do |arg, kw|
      arg.start_with?(kw[:pattern])
    end

    function "strip_newlines", unnamed_arg: :string do |arg,|
      arg.gsub("\n", "")
    end

    function "join", unnamed_arg: :tuple,
                     optional_named_args: { with: :string } do |arg, kw|
      arg.flatten.join(kw[:with] || ' ')
    end

    function "split", unnamed_arg: :string,
                      optional_named_args: { by: :string } do |arg, kw|
      arg.split(kw[:by] || ' ')
    end

    function "replace",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
                replacement: :string
              } do |arg, kw|
      arg.gsub kw[:pattern], kw[:replacement]
    end

    function "replace_first",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
                replacement: :string
              } do |arg, kw|
      arg.sub kw[:pattern], kw[:replacement]
    end

    function "remove",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
              } do |arg, kw|
      arg.gsub kw[:pattern], ''
    end

    function "remove_first",
              unnamed_arg: :string,
              mandatory_named_args: {
                pattern: :string,
              } do |arg, kw|
      arg.sub kw[:pattern], ''
    end

    function "newline_to_br", unnamed_arg: :string do |arg,|
      arg.gsub(/\n/, "<br>\n")
    end

    function "url_escape", unnamed_arg: :string do |arg,|
      URI.encode_www_form_component(arg)
    end

    function "html_escape", unnamed_arg: :string do |arg,|
      if defined?(Rack::Utils)
        Rack::Utils.escape_html(arg)
      else
        raise NotImplementedError, "html_escape() requires Rack"
      end
    end

    function "html_escape_once", unnamed_arg: :string do |arg,|
      if defined?(ActionView)
        @html_escape_once_helper ||= Object.new.
            tap { |obj| obj.extend ActionView::Helpers::TagHelper }
        @html_escape_once_helper.escape_once(arg)
      else
        raise NotImplementedError, "html_escape_once() requires ActionView"
      end
    end
    function_alias "h", "html_escape_once"

    function "strip_html", unnamed_arg: :string do |arg,|
      if defined?(HTML::Sanitizer)
        HTML::FullSanitizer.new.sanitize(arg)
      else
        raise NotImplementedError, "escape_once() requires HTML::Sanitizer (try loading ActionView)"
      end
    end

    function "decode_html_entities", unnamed_arg: :string do |arg,|
      if defined?(HTMLEntities)
        HTMLEntities.new.decode(arg)
      else
        raise NotImplementedError, "decode_html_entities() requires HTMLEntities"
      end
    end

    #
    # Tuple functions
    #

    function "uniq", unnamed_arg: :tuple do |arg,|
      arg.uniq
    end

    function "compact", unnamed_arg: :tuple do |arg,|
      arg.compact
    end

    function "reverse", unnamed_arg: :tuple do |arg,|
      arg.reverse
    end

    function "in_groups_of",
              unnamed_arg: [:tuple],
              mandatory_named_args: { size: :integer },
              optional_named_args:  { fill_with: :string } do |arg, kw|
      if [].respond_to? :in_groups_of
        arg.to_a.in_groups_of(kw[:size], kw[:fill_with])
      else
        raise NotImplementedError, "in_groups_of() requires ActiveSupport Array extensions"
      end
    end

    function "in_groups",
              unnamed_arg: [:tuple],
              mandatory_named_args: { count: :integer },
              optional_named_args:  { fill_with: :string } do |arg, kw|
      if [].respond_to? :in_groups
        arg.to_a.in_groups(kw[:count], kw[:fill_with])
      else
        raise NotImplementedError, "in_groups() requires ActiveSupport Array extensions"
      end
    end

    # DEPRECATED
    function "includes",
              unnamed_arg: :tuple,
              mandatory_named_args: { element: :any } do |arg, kw|
      arg.include?(kw[:element])
    end

    #
    # Intelligent truncation functions
    #

    function "truncate",
              unnamed_arg: :string,
              optional_named_args: {
                length:   :integer,
                omission: :string
              } do |arg, kw|
      length   = kw[:length]   || 50
      omission = kw[:omission] || '...'

      truncate_at = length - kw[:omission].length
      truncate_at = 0 if length < 0

      if arg.length > length
        arg[0...truncate_at] + omission
      else
        arg
      end
    end

    function "truncate_words",
              unnamed_arg: :string,
              optional_named_args: {
                words:    :integer,
                omission: :string
              } do |arg, kw|
      words    = arg.split
      length   = kw[:words]    || 15
      omission = kw[:omission] || '...'

      if words.length > length
        words[0...length].join(" ") + omission
      else
        words.join(" ")
      end
    end

    function "html_truncate",
              unnamed_arg: :string,
              optional_named_args: {
                length:   :integer,
                omission: :string
              } do |arg, kw|
      length   = kw[:length]   || 50
      omission = kw[:omission] || '...'

      if defined?(Nokogiri)
        HTMLTruncater.truncate(arg, length, omission)
      else
        raise NotImplementedError, "html_truncate() requires Nokogiri"
      end
    end

    function "html_truncate_words",
              unnamed_arg: :string,
              optional_named_args: {
                words:    :integer,
                omission: :string
              } do |arg, kw|
      length   = kw[:words]    || 15
      omission = kw[:omission] || '...'

      if defined?(Nokogiri)
        HTMLTruncater.truncate_words(arg, length, omission)
      else
        raise NotImplementedError, "html_truncate_words() requires Nokogiri"
      end
    end

  end
end
