#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/helper'

class FileSystemTest < Test::Unit::TestCase
  include Liquor
  
  def test_default
    assert_raise(FileSystemError) do
      BlankFileSystem.new.read_template_file("dummy")
    end
  end
  
  def test_local
    file_system = Liquor::LocalFileSystem.new("/some/path")
    assert_equal "/some/path/_mypartial.liquor"    , file_system.full_path("mypartial")   
    assert_equal "/some/path/dir/_mypartial.liquor", file_system.full_path("dir/mypartial")

    assert_raise(FileSystemError) do
      file_system.full_path("../dir/mypartial")
    end

    assert_raise(FileSystemError) do
      file_system.full_path("/dir/../../dir/mypartial")      
    end

    assert_raise(FileSystemError) do
      file_system.full_path("/etc/passwd")
    end
  end
end