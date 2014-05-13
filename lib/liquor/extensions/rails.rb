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
  class Request
    include Liquor::External

    def initialize(request, controller)
      @request    = request
      @controller = controller
    end

    delegate :url,     to: :@request
    delegate :path,    to: :@request
    delegate :referer, to: :@request

    export :url, :path, :referer

    def param(arg, kw={})
      escape_params(@request.params)[arg.to_s]
    end

    def escape_params(input)
      case input
      when String
        Rack::Utils.escape_html(input)
      when Array
        input.map &method(:escape_params)
      when Hash
        Hash[input.map { |k, v| [k.to_s, escape_params(v)] }]
      end
    end

    export :param

    def controller
      @controller.controller_name
    end

    def action
      @controller.action_name
    end

    export :controller, :action

    def form_authenticity_token
      # Sorry for sends
      if @controller.send(:protect_against_forgery?)
        @controller.send(:form_authenticity_token)
      end
    end

    export :form_authenticity_token
  end

  class TemplateLoader
    # TODO
  end

  class LogSubscriber < ActiveSupport::LogSubscriber
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
