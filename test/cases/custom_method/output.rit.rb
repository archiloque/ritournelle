# @param [Ritournelle::Runtime::StdLib::Integer] number
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is add_two
def add_two—0(number)
  return number.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(2))
end
# @type [Ritournelle::Runtime::StdLib::Integer]
i =
  Ritournelle::Runtime::StdLib::Integer.new(10)
# @type [Ritournelle::Runtime::StdLib::Integer]
j =
  self.add_two—0(i)
# @type [Ritournelle::Runtime::StdLib::Integer]
k =
  self.add_two—0(Ritournelle::Runtime::StdLib::Integer.new(10))