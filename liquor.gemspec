# -*- encoding: utf-8 -*-
require File.expand_path('../lib/liquor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ivan Evtukhovich"]
  gem.email         = ["evtuhovich@gmail.com"]
  gem.description   = %q{Liquor is a safe (not evaling) template language based on Liquid template language}
  gem.summary       = %q{Liquor is a safe (not evaling) template language based on Liquid template language. Safe means that templates cannot affect security of the server they are rendered on. So it is usable when you need to give an ability to edit templates to your users (HTML or email).}
  gem.homepage      = "https://github.com/evilmartians/liquor"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "liquor"
  gem.require_paths = ["lib"]
  gem.version       = Liquor::VERSION

  gem.add_dependency 'rails', '~> 3.2.0'
end
