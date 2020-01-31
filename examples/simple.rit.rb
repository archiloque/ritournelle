i =
  Ritournelle::Runtime::StdLib::Int.new(10)
j =
  Ritournelle::Runtime::StdLib::Int.new(20)
i.plus_Int(Ritournelle::Runtime::StdLib::Int.new(10))
i.plus_Int(j)
f =
  Ritournelle::Runtime::StdLib::Float.new(10.5)
g =
  j.to_float()

# @return [Ritournelle::Runtime::StdLib::Int]
def two—0()
  return Ritournelle::Runtime::StdLib::Int.new(2)
end

l =
  self.two—0()

# @param [Ritournelle::Runtime::StdLib::Int] number
# @return [Ritournelle::Runtime::StdLib::Int]
def add_two—1(number)
  return number.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
end


# @param [Ritournelle::Runtime::StdLib::Float] number
# @return [Ritournelle::Runtime::StdLib::Float]
def add_two—2(number)
  return number.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
end

m =
  add_two—1(Ritournelle::Runtime::StdLib::Int.new(10))
n =
  add_two—1(m)
o =
  add_two—2(Ritournelle::Runtime::StdLib::Float.new(10.0))
p =
  add_two—2(o)

class Circle
  
  # @return [void]
  def draw—0()
  end
  
end
