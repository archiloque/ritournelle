
# @param [Ritournelle::Runtime::StdLib::Int] number
# @return [Ritournelle::Runtime::StdLib::Int]
def add_two—0(number)
  return number.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
end


# @param [Ritournelle::Runtime::StdLib::Float] number
# @return [Ritournelle::Runtime::StdLib::Float]
def add_two—1(number)
  return number.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
end

i =
  Ritournelle::Runtime::StdLib::Int.new(10)
j =
  self.add_two—0(i)
k =
  self.add_two—0(Ritournelle::Runtime::StdLib::Int.new(10))
l =
  Ritournelle::Runtime::StdLib::Float.new(10.0)
m =
  self.add_two—1(l)
n =
  self.add_two—1(Ritournelle::Runtime::StdLib::Float.new(10.0))