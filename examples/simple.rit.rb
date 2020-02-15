# @type [Ritournelle::Runtime::StdLib::Int]
i =
  Ritournelle::Runtime::StdLib::Int.new(10)
# @type [Ritournelle::Runtime::StdLib::Int]
j =
  Ritournelle::Runtime::StdLib::Int.new(20)
j =
  Ritournelle::Runtime::StdLib::Int.new(20)
i.plus_Int(Ritournelle::Runtime::StdLib::Int.new(10))
i.plus_Int(j)
# @type [Ritournelle::Runtime::StdLib::Float]
f =
  Ritournelle::Runtime::StdLib::Float.new(10.5)
# @type [Ritournelle::Runtime::StdLib::Float]
g =
  j.to_float()
# @type [Ritournelle::Runtime::StdLib::Float]
h = g

# @return [Ritournelle::Runtime::StdLib::Int]
def two—0()
  # @type [Ritournelle::Runtime::StdLib::Int]
  t =
    Ritournelle::Runtime::StdLib::Int.new(2)
  return Ritournelle::Runtime::StdLib::Int.new(2)
end


# @return [Ritournelle::Runtime::StdLib::Int]
def three—1()
  # @type [Ritournelle::Runtime::StdLib::Int]
  t =
    Ritournelle::Runtime::StdLib::Int.new(3)
  return t
end

# @type [Ritournelle::Runtime::StdLib::Int]
l =
  self.two—0()

# @param [Ritournelle::Runtime::StdLib::Int] number
# @return [Ritournelle::Runtime::StdLib::Int]
def add_two—2(number)
  return number.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
end


# @param [Ritournelle::Runtime::StdLib::Float] number
# @return [Ritournelle::Runtime::StdLib::Float]
def add_two—3(number)
  return number.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
end

# @type [Ritournelle::Runtime::StdLib::Int]
m =
  self.add_two—2(Ritournelle::Runtime::StdLib::Int.new(10))
# @type [Ritournelle::Runtime::StdLib::Int]
n =
  self.add_two—2(m)
# @type [Ritournelle::Runtime::StdLib::Float]
o =
  self.add_two—3(Ritournelle::Runtime::StdLib::Float.new(10.0))
# @type [Ritournelle::Runtime::StdLib::Float]
p =
  self.add_two—3(o)

class Circle
  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  
  # @return [Ritournelle::Runtime::StdLib::Float]
  def x—0()
    return @x
  end
  
  
  # @return [Ritournelle::Runtime::StdLib::Float]
  def y—1()
    return @y
  end
  
  
  # @return [Ritournelle::Runtime::StdLib::Float]
  def radius—2()
    return @radius
  end
  
  
  # @param [Ritournelle::Runtime::StdLib::Float] radius
  # @return [void]
  def radius—3(radius)
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
  def draw—4()
  end
  
  
  # @return [Ritournelle::Runtime::StdLib::Float]
  def x_plus2—5()
    return @x.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
  end
  
end

# @type [Circle]
c =
  Circle.new(0, Ritournelle::Runtime::StdLib::Float.new(1.0), Ritournelle::Runtime::StdLib::Float.new(2.0), Ritournelle::Runtime::StdLib::Float.new(3.0))
c.draw—4()
c.x—0()