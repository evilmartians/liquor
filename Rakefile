#!/usr/bin/env rake
require "bundler/gem_tasks"

file 'lib/liquor/parser.rb' => 'lib/liquor/parser.rl' do
  %x{ragel -R lib/liquor/parser.rl}
end

file 'doc/language-spec.html' => 'doc/language-spec.md' do
  %x{kramdown --template document doc/language-spec.md >doc/language-spec.html}
end

task :default => [ 'lib/liquor/parser.rb', 'doc/language-spec.html' ]