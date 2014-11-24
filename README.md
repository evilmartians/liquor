# Liquor

Liquor is a safe and extensible templating language that compiles to Ruby.
It can be thought of as a replacement of [Liquid](https://github.com/Shopify/liquid),
though it does not provide a migration path.

## Installation

Add this line to your application's Gemfile:

    gem 'liquor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install liquor

## Usage

The language is described in [the specification](http://evilmartians.github.io/liquor/language-spec.html).

### Compiling templates

The Liquor templates are rendered in two stages. First, you need to compile them using `Liquor::Manager`. Assuming `templates` is a hash mapping template names to contents and predefined variables, the following code demonstrates the usage of `Liquor::Manager`:

``` ruby
manager = Liquor::Manager.new

templates.each do |name, (body, predefined)|
  if manager.partial? name
    manager.register_partial name, body
  else
    manager.register_template name, body, predefined
  end
end

unless manager.compile
  manager.errors.each do |error|
    source, * = templates[error.location[:file]]
    puts error.decorate(source)
  end
end
```

The `error.decorate` call will extract the corresponding line from the source and highlight the character range that caused the error.

### Rendering templates

The `context` is a hash that is shared between the layout and the inner template. The `layout_environment` and `inner_environment` contain the list of variables initially provided to corresponding template; it must match the value of `predefined` of the template at compilation time.

``` ruby
context ||= {}

# Production-mode code
diagnostics = Liquor::Runtime.capture_diagnostics do
  inner = manager.render(template_name, inner_environment, context)
  manager.render(layout_name, layout_environment, context.merge(_inner_template: inner))
end

# Development-mode code
Liquor::Runtime.with_fatal_deprecations do
  # idem
end
```

The difference between development-mode and production-mode code is that in development mode, all runtime errors are raised as `Liquor::Diagnostic` exceptions, and in production mode, they are returned from `Liquor::Runtime.capture_diagnostics` instead.

The code to perform decoration of the errors is the same as for compile-time errors.

Additionally, both development-mode and production-mode code can raise `Liquor::HostError` at render time, reserved for uncaught Ruby exceptions inside Liquor code.

### Extending Liquor

Liquor _functions_ are similar to Ruby functions. They should not have any side effects. To learn how to define your own Liquor functions, see [lib/stdlib/builtin_functions.rb](lib/stdlib/builtin_functions.rb).

Liquor _tags_ provide means for inserting arbitrary Ruby code in the compiled output. They can do almost anything, and can have side effects. To learn how to define your own Liquor tags, see [lib/stdlib/builtin_tags.rb](lib/stdlib/builtin_tags.rb).

Both functions and tags are organized in _libraries_. A Liquor library looks like this:

``` ruby
module LiquorFoo
  include Liquor::Library

  function # ...

  tag # ...
end
```

The libraries should be provided to the `Liquor::Manager` constructor, e.g. `Liquor::Manager.new(import: [LiquorFoo])`.

### Passing Ruby objects to Liquor code

Liquor represents primitive Liquor objects (null, booleans, integers, strings and tuples) using the corresponding primitive Ruby objects, so they can be passed as-is. Liquor does not extend core Ruby classes.

All other objects must include `Liquor::External` in order to be accessible from Liquor. They need to call `export` on module level to explicitly mark functions as accessible to Liquor. The functions always receive two arguments: the unnamed argument and the hash of keyword arguments, e.g.:

``` ruby
class FooExternal
  include Liquor::External

  def meth(arg, kwargs)
    # ...
  end
  export :meth
```

Additionally, external methods can be deprecated using `deprecate :meth, date: '2014-11-11', message: 'meth is deprecated, use meth1 instead'`. The _date_ (i.e. the intended date of final removal) and _message_ will appear in the message of the emitted `Liquor::Diagnostic`. The diagnostic will only be emitted when the method is actually called.

### Library integrations

Liquor contains code to integrate with some popular libraries

#### ActiveRecord

Liquor contains built-in support for passing ActiveRecord scopes and model instances as externals. To use it, `require 'liquor/dropable'`, then `include Liquor::Dropable` in the model, and then simply pass the scope or model instance to the template.

#### Rails

Liquor contains a Rails renderer for Liquor templates that supports layouts. To use it, use the following code in your actions:

``` ruby
render liquor: {
         manager:     manager,
         template:    template_name,
         layout:      layout_name,
         environment: environment,
       }
```

See the section "Renering templates" for the meaning of the renderer arguments.

#### Kaminari

To use Kaminari integration, `require 'liquor/extensions/kaminari'`. This will monkey-patch `Kaminari::PaginatableArray` and allow to pass any object paginated by Kaminari to Liquor templates.

#### Tire

To use Tire integration, `require 'liquor/extensions/tire'`. This will monkey-patch `Tire::Results::Collection` and `Tire::Search::Search` and allow to pass any object generated by Tire to Liquor templates.

#### ThinkingSphinx

To use ThinkingSphinx integration, `require 'liquor/extensions/thinking_sphinx'`. This will monkey-patch `ThinkingSphinx::Search` and allow to pass any object generated by ThinkingSphinx to Liquor templates.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Liquor is distributed under the terms of [MIT license](MIT-LICENSE).
