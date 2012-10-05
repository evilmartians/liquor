require 'rails'

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
