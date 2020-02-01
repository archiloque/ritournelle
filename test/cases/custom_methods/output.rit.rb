
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

# @type [Ritournelle::Runtime::StdLib::Int]
i =
  Ritournelle::Runtime::StdLib::Int.new(10)
# @type [Ritournelle::Runtime::StdLib::Int]
j =
  self.add_two—0(i)
# @type [Ritournelle::Runtime::StdLib::Int]
k =
  self.add_two—0(Ritournelle::Runtime::StdLib::Int.new(10))
# @type [Ritournelle::Runtime::StdLib::Float]
l =
  Ritournelle::Runtime::StdLib::Float.new(10.0)
# @type [Ritournelle::Runtime::StdLib::Float]
m =
  self.add_two—1(l)
# @type [Ritournelle::Runtime::StdLib::Float]
n =
  self.add_two—1(Ritournelle::Runtime::StdLib::Float.new(10.0))