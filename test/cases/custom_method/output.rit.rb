
# @param [Ritournelle::Runtime::StdLib::Int] number
# @return [Ritournelle::Runtime::StdLib::Int]
def add_two(number)
  return number.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
end

i =
  Ritournelle::Runtime::StdLib::Int.new(10)
j =
  self.add_two(i)
k =
  self.add_two(Ritournelle::Runtime::StdLib::Int.new(10))