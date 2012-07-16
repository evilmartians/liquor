guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/liquor/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { "spec" }

  watch(%r{^lib/liquor/grammar/.+\.(rl|racc)$}) { `rake`; "spec" }

  notification :libnotify
end