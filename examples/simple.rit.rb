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
def two()
  return Ritournelle::Runtime::StdLib::Int.new(2)
end

m =
  self.two()

# @param [Ritournelle::Runtime::StdLib::Int] number
# @return [Ritournelle::Runtime::StdLib::Int]
def add_two(number)
  return number.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
end

l =
  self.add_two(Ritournelle::Runtime::StdLib::Int.new(10))
n =
  self.add_two(l)

class Circle
  
  # @return [void]
  def draw()
  end
  
end
