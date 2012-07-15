#!/usr/bin/env rake

require "bundler/gem_tasks"

file 'lib/liquor/lexer.rb' => 'lib/liquor/grammar/lexer.rl' do
  sh "ragel -R lib/liquor/grammar/lexer.rl -o lib/liquor/lexer.rb"
end

file 'lib/liquor/parser.rb' => 'lib/liquor/grammar/parser.racc' do
  sh "racc lib/liquor/grammar/parser.racc -o lib/liquor/parser.rb"
end

file 'doc/language-spec.html' => 'doc/language-spec.md' do
  sh "kramdown --template document doc/language-spec.md >doc/language-spec.html"
end

task :default => [ 'lib/liquor/lexer.rb', 'lib/liquor/parser.rb', 'doc/language-spec.html' ]