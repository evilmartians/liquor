require 'rails'

ActionController::Renderers.add :liquor do |options, *|
  output = nil
  manager, name, layout_name, environment, storage = \
        options.values_at(:manager, :template, :layout, :environment, :storage)

  storage ||= {}

  ActiveSupport::Notifications.instrument("render_template.action_view",
        identifier: name, layout: layout_name) do
    if layout_name
      output = manager.render_with_layout(layout_name, environment,
                  name, environment, storage)
    else
      output = manager.render(name, environment, storage)
    end
  end

  render :text => output
end
