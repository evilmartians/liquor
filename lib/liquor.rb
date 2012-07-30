require "liquor/version"

module Liquor
  require "liquor/errors"
  require "liquor/lexer"
  require "liquor/parser"

  require "liquor/runtime"

  require "liquor/ast_tools"
  require "liquor/emitter"
  require "liquor/context"

  require "liquor/tag"
  require "liquor/function"
  require "liquor/external"

  require "liquor/library"

  require "liquor/builtins"
  require "liquor/partials"

  require "liquor/compiler"
  require "liquor/manager"

  require "liquor/drop"

  if defined?(ActiveRecord)
    require "liquor/extensions/active_record"
  end

  if defined?(Rails)
    require "liquor/extensions/rails"
  end
end
