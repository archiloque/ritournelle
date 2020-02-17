
# @!parse
#   # @abstract
#   module MyInterface
#     # @param [Ritournelle::Runtime::StdLib::Int] value
#     # @return [Ritournelle::Runtime::StdLib::Int]
#     # @abstract
#     # @note Declared name is add_two
#     def add_two—0(value)
#     end
#     
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
  
  # @param [Ritournelle::Runtime::StdLib::Int] value
  # @return [Ritournelle::Runtime::StdLib::Int]
  # @note Declared name is add_two
  def add_two—0(value)
    return value.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
  end
end

# @type [MyInterface]
interface =
  MyClass.new(0, )
interface.add_two—0(Ritournelle::Runtime::StdLib::Int.new(5))