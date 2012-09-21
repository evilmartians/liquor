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

ActionController::Renderers.add :liquor do |options, *|
  output = nil
  manager, name, layout_name, environment = \
        options.values_at(:manager, :template, :layout, :environment)

  ActiveSupport::Notifications.instrument("render_template.action_view",
        identifier: name, layout: layout_name) do
    if layout_name
      output = manager.render_with_layout(layout_name, environment, name, environment)
    else
      output = manager.render(name, environment)
    end
  end

  render :text => output
end
