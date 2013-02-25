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

module Liquor::Rails
  class TemplateLoader
    # TODO
  end

  class LogSubscriber
    def load_template(event)
      line(event, "  Template Load", color: WHITE, info: "#{event.payload[:name]}")
    end

    def load(event)
      line(event, "Template Load All", color: CYAN)
    end

    def compile(event)
      line(event, "Template Compile", color: CYAN)
    end

    def logger
      ActionController::Base.logger
    end

    protected

    def line(event, what, options={})
      if options[:color]
        what = color(what, options[:color], true)
      end

      debug("  %s (%.1fms)  %s" % [what, event.duration, options[:info]])
    end
  end

  LogSubscriber.attach_to :liquor
end
