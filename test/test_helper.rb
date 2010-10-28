#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__)+ '/extra')

require 'test/unit'
require 'test/unit/assertions'
require 'caller'
require 'breakpoint'
require 'active_record'
require 'action_controller'
require File.dirname(__FILE__) + '/../lib/liquid'


ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)


module Test
  module Unit
    module Assertions
        include Liquor
        def assert_template_result(expected, template, assigns={}, message=nil)
          assert_equal expected, Template.parse(template).render(assigns)
        end 
    end
  end
end