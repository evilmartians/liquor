#!/usr/bin/env rake

require "bundler/gem_tasks"

file 'lib/liquor/lexer.rb' => 'lib/liquor/lexer.rl' do
  sh "ragel -R lib/liquor/lexer.rl"
end

file 'lib/liquor/parser.rb' => 'lib/liquor/parser.racc' do
  sh "racc lib/liquor/parser.racc -o lib/liquor/parser.rb"
end

file 'doc/language-spec.html' => 'doc/language-spec.md' do
  sh "kramdown --template document doc/language-spec.md >doc/language-spec.html"
end

task :default => [ 'lib/liquor/lexer.rb', 'lib/liquor/parser.rb', 'doc/language-spec.html' ]