source 'https://rubygems.org'

# Specify your gem's dependencies in liquor.gemspec
gemspec

group :development do
  if RUBY_PLATFORM =~ /linux/i
    gem 'rb-inotify', '~> 0.8.8'
    gem 'libnotify'
  end
end
