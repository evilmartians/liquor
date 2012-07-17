guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch('lib/liquor.rb') { "spec" }
  watch(%r{^lib/liquor/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb') { "spec" }

  watch(%r{^lib/liquor/grammar/.+\.(rl|racc)$}) { `rake` }

  notification :libnotify
end