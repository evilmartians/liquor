# Copyright 2007 by Domizio Demichelis
# This library is free software. It may be used, redistributed and/or modified
# under the same terms as Ruby itself
#
# This extension is usesd in order to expose the object of the implementing class
# to liquor as it were a Drop. It also limits the liquor-callable methods of the instance
# to the allowed method passed with the liquor_methods call
# Example:
#
# class SomeClass
#   liquor_methods :an_allowed_method
#
#   def an_allowed_method
#     'this comes from an allowed method'
#   end
#   def unallowed_method
#     'this will never be an output'
#   end
# end
#
# if you want to extend the drop to other methods you can defines more methods
# in the class <YourClass>::LiquorDropClass
#
#   class SomeClass::LiquorDropClass
#     def another_allowed_method
#       'and this from another allowed method'
#     end
#   end
# end
#
# usage:
# @something = SomeClass.new
#
# template:
# {{something.an_allowed_method}}{{something.unallowed_method}} {{something.another_allowed_method}}
#
# output:
# 'this comes from an allowed method and this from another allowed method'
#
# You can also chain associations, by adding the liquor_method call in the
# association models.
#
class Module

  def liquor_methods(*allowed_methods)
    drop_class_str = "class #{self.to_s}::LiquorDropClass < Liquor::Drop\n"
    drop_class_str += "liquor_attributes << #{allowed_methods.collect{|meth| ":#{meth}"}.join(" << ") }\n" if allowed_methods.present?
    drop_class_str += "self\n"
    drop_class_str += "end"
    
    drop_class = eval drop_class_str

    define_method :to_liquor do
      drop_class.new(self)
    end
  end

end
