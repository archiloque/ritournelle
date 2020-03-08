
class MyClass
  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  # @return [X]
  # @note Declared name is x
  def x—0()
    return @x
  end
  # @param [X] x
  # @return [void]
  # @note Declared name is x=
  def x—1(x)
    @x = x
  end
  # @return [Y]
  # @note Declared name is y
  def y—2()
    return @y
  end
  
  # @param [X] x
  # @param [Y] y
  def initialize—0(x, y)
    @x = x
    @y = y
  end
  
end

# @type [MyClass<Integer, Float>]
c =
  MyClass.new(0, Ritournelle::Runtime::StdLib::Integer.new(10), Ritournelle::Runtime::StdLib::Float.new(12.5))
c.x—1(Ritournelle::Runtime::StdLib::Integer.new(11))
# @type [Ritournelle::Runtime::StdLib::Integer]
i =
  c.x—0()
# @type [MyClass<Integer, Float>]
d = c