
# @!parse
#   # @abstract
#   module MyInterface
#   end


class MyClass
  # @!parse
  #   include MyInterface

  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  
  def initialize—0()
  end
  
end

# @param [MyInterface] my_interface
# @return [void]
# @note Declared name is do_nothing
def do_nothing—0(my_interface)
end
# @param [MyInterface] my_interface
# @param [Ritournelle::Runtime::StdLib::Integer] value
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is add_two
def add_two—1(my_interface, value)
  return value.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(2))
end
# @type [MyClass]
my_class =
  MyClass.new(0, )
self.do_nothing—0(my_class)
self.add_two—1(my_class, Ritournelle::Runtime::StdLib::Integer.new(5))