
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
# @param [Ritournelle::Runtime::StdLib::Int] value
# @return [Ritournelle::Runtime::StdLib::Int]
# @note Declared name is add_two
def add_two—0(my_interface, value)
  return value.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
end
# @type [MyClass]
my_class =
  MyClass.new(0, )
self.add_two—0(my_class, Ritournelle::Runtime::StdLib::Int.new(5))