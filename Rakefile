require "bundler/gem_tasks"
require 'rspec/core/rake_task'

file 'lib/liquor/grammar/lexer.rb' => 'lib/liquor/grammar/lexer.rl' do
  sh "ragel -R lib/liquor/grammar/lexer.rl -o lib/liquor/grammar/lexer.rb"
end

file 'lib/liquor/grammar/parser.rb' => 'lib/liquor/grammar/parser.racc' do
  sh "racc lib/liquor/grammar/parser.racc -o lib/liquor/grammar/parser.rb"
end

file 'doc/language-spec.html' => 'doc/language-spec.md' do
  sh "kramdown --template document doc/language-spec.md >doc/language-spec.html"
end

desc "Regenerate everything (grammar, docs) and run specs."
task :default => [
  'lib/liquor/grammar/lexer.rb',
  'lib/liquor/grammar/parser.rb',
  'doc/language-spec.html',
  :spec
]

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
  t.rspec_opts = %w(-fs --color)
end
