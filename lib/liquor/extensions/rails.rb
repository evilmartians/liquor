require 'rails'

module Liquor
  module Builtins
    function "escape_once", unnamed_arg: :string do |arg,|
      ActionView::Helpers::TagHelper.escape_once(input)
    end
    function_alias "h", "escape_once"

    function "strip_html", unnamed_arg: :string do |arg,|
      ActionView::Helpers::SanitizeHelper.strip_tags(arg)
    end

    function "decode_html_entities", unnamed_arg: :string do |arg,|
      HTMLEntities.new.decode(arg)
    end
  end
end