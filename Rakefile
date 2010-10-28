#!/usr/bin/env ruby
require 'rubygems'
require 'rake'
require 'rake/testtask'

PKG_VERSION = "1.0.0"
PKG_NAME    = "liquor"
PKG_DESC    = "A secure non evaling end user template engine with aesthetic markup based on Liquor template engine."

Rake::TestTask.new(:test) do |t|
  t.libs << '.' << 'lib' << 'test'
  t.pattern = 'test/*_test.rb'
  t.verbose = false
end

namespace :profile do
  task :default => [:run]
  
  desc "Run the liquor profile/perforamce coverage"
  task :run do
  
    ruby "performance/shopify.rb"
  
  end
  
  desc "Run KCacheGrind" 
  task :grind => :run  do
    system "kcachegrind /tmp/liquor.rubyprof_calltreeprinter.txt"
  end
end
  
  