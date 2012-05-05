require 'time'
require 'date'

class String # :nodoc:
  def to_liquor
    self
  end
end

class Array  # :nodoc:
  def to_liquor
    self
  end
end

class Hash  # :nodoc:
  def to_liquor
    self
  end
end

class Numeric  # :nodoc:
  def to_liquor
    self
  end
end

class Time  # :nodoc:
  def to_liquor
    self
  end
end

class DateTime < Date  # :nodoc:
  def to_liquor
    self
  end
end

class Date  # :nodoc:
  def to_liquor
    self
  end
end

def true.to_liquor  # :nodoc:
  self
end

def false.to_liquor # :nodoc:
  self
end

def nil.to_liquor # :nodoc:
  self
end

class ActiveRecord::Relation
  def to_liquor
    self
  end
end

class ActionDispatch::Request
  def to_liquor
    Liquor::RequestDrop.new self
  end
end

class Liquor::RequestDrop < Liquor::Drop
  allow_all_methods
end