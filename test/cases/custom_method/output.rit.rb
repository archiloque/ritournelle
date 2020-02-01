
# @param [Ritournelle::Runtime::StdLib::Int] number
# @return [Ritournelle::Runtime::StdLib::Int]
def add_two—0(number)
  return number.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
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