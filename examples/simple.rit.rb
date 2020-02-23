# @type [Ritournelle::Runtime::StdLib::Integer]
i =
  Ritournelle::Runtime::StdLib::Integer.new(10)
# @type [Ritournelle::Runtime::StdLib::Integer]
j =
  Ritournelle::Runtime::StdLib::Integer.new(-20)
j =
  Ritournelle::Runtime::StdLib::Integer.new(20)
i.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(10))
i.plus_Integer(j)
# @type [Ritournelle::Runtime::StdLib::Float]
f =
  Ritournelle::Runtime::StdLib::Float.new(10.5)
# @type [Ritournelle::Runtime::StdLib::Float]
g =
  j.to_float()
# @type [Ritournelle::Runtime::StdLib::Boolean]
b =
  Ritournelle::Runtime::StdLib::Boolean.new(true)
b =
  i.less_than_Integer(j)
if b.value
  i =
    Ritournelle::Runtime::StdLib::Integer.new(30)
end
if i.less_than_Integer(j)
  i =
    Ritournelle::Runtime::StdLib::Integer.new(40)
end
# @type [Ritournelle::Runtime::StdLib::Float]
h = g
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is two
def two—0()
  # @type [Ritournelle::Runtime::StdLib::Integer]
  t =
    Ritournelle::Runtime::StdLib::Integer.new(2)
  return Ritournelle::Runtime::StdLib::Integer.new(2)
end
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is three
def three—1()
  # @type [Ritournelle::Runtime::StdLib::Integer]
  t =
    Ritournelle::Runtime::StdLib::Integer.new(3)
  return t
end
# @type [Ritournelle::Runtime::StdLib::Integer]
l =
  self.two—0()
# @param [Ritournelle::Runtime::StdLib::Integer] number
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is add_two
def add_two—2(number)
  return number.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(2))
end
# @param [Ritournelle::Runtime::StdLib::Float] number
# @return [Ritournelle::Runtime::StdLib::Float]
# @note Declared name is add_two
def add_two—3(number)
  return number.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
end
# @type [Ritournelle::Runtime::StdLib::Integer]
m =
  self.add_two—2(Ritournelle::Runtime::StdLib::Integer.new(10))
# @type [Ritournelle::Runtime::StdLib::Integer]
n =
  self.add_two—2(m)
# @type [Ritournelle::Runtime::StdLib::Float]
o =
  self.add_two—3(Ritournelle::Runtime::StdLib::Float.new(10.0))
# @type [Ritournelle::Runtime::StdLib::Float]
p =
  self.add_two—3(o)

# @!parse
#   # @abstract
#   module Drawable
#     # @return [void]
#     # @abstract
#     # @note Declared name is draw
#     def draw—4()
#     end
#     
#   end


class Circle
  # @!parse
  #   include Drawable

  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  # @return [Ritournelle::Runtime::StdLib::Float]
  # @note Declared name is x
  def x—5()
    return @x
  end
  # @return [Ritournelle::Runtime::StdLib::Float]
  # @note Declared name is y
  def y—6()
    return @y
  end
  # @return [Ritournelle::Runtime::StdLib::Float]
  # @note Declared name is radius
  def radius—7()
    return @radius
  end
  # @param [Ritournelle::Runtime::StdLib::Float] radius
  # @return [void]
  # @note Declared name is radius=
  def radius—8(radius)
    @radius = radius
  end
  
  # @param [Ritournelle::Runtime::StdLib::Float] x
  # @param [Ritournelle::Runtime::StdLib::Float] y
  # @param [Ritournelle::Runtime::StdLib::Float] radius
  def initialize—0(x, y, radius)
    @x = x
    @y = y
    @radius = radius
  end
  
  # @return [void]
  # @note Declared name is draw
  def draw—4()
  end
  # @return [Ritournelle::Runtime::StdLib::Float]
  # @note Declared name is x_plus2
  def x_plus2—9()
    return @x.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
  end
end

# @param [Drawable] d
# @return [void]
# @note Declared name is do_something
def do_something—10(d)
end
# @type [Circle]
c =
  Circle.new(0, Ritournelle::Runtime::StdLib::Float.new(1.0), Ritournelle::Runtime::StdLib::Float.new(2.0), Ritournelle::Runtime::StdLib::Float.new(3.0))
c.draw—4()
self.do_something—10(c)