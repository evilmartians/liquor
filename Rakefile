#!/usr/bin/env rake
require "bundler/gem_tasks"

file 'lib/liquor/lexer.rb' => 'lib/liquor/lexer.rl' do
  sh "ragel -R lib/liquor/lexer.rl"
end

file 'doc/language-spec.html' => 'doc/language-spec.md' do
  sh "kramdown --template document doc/language-spec.md >doc/language-spec.html"
end

task :default => [ 'lib/liquor/lexer.rb', 'doc/language-spec.html' ]