# -*- encoding: utf-8 -*-
require File.expand_path('../lib/liquor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Zotov"]
  gem.email         = ["whitequark@whitequark.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "liquor"
  gem.require_paths = ["lib"]
  gem.version       = Liquor::VERSION

  gem.required_ruby_version = '>= 1.9'

  # Generation of the parsers and documentation.
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'racc'
  gem.add_development_dependency 'kramdown'

  # Testing.
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'

  # Testing dependencies.
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'nokogiri'
  gem.add_development_dependency 'htmlentities'
  gem.add_development_dependency 'sqlite3'
end
