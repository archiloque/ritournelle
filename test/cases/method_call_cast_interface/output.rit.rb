
# @!parse
#   # @abstract
#   module MyInterface
#     # @param [Ritournelle::Runtime::StdLib::Integer] value
#     # @return [Ritournelle::Runtime::StdLib::Integer]
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
  
  # @param [Ritournelle::Runtime::StdLib::Integer] value
  # @return [Ritournelle::Runtime::StdLib::Integer]
  # @note Declared name is add_two
  def add_two—0(value)
    return value.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(2))
  end
end

# @type [MyInterface]
interface =
  MyClass.new(0, )
interface.add_two—0(Ritournelle::Runtime::StdLib::Integer.new(5))