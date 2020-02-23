# @param [Ritournelle::Runtime::StdLib::Integer] number
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is add_two
def add_two—0(number)
  return number.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(2))
end
# @param [Ritournelle::Runtime::StdLib::Float] number
# @return [Ritournelle::Runtime::StdLib::Float]
# @note Declared name is add_two
def add_two—1(number)
  return number.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
end
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is four
def four—2()
  # @type [Ritournelle::Runtime::StdLib::Integer]
  f =
    Ritournelle::Runtime::StdLib::Integer.new(4)
  return f
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
# @type [Ritournelle::Runtime::StdLib::Float]
l =
  Ritournelle::Runtime::StdLib::Float.new(10.0)
# @type [Ritournelle::Runtime::StdLib::Float]
m =
  self.add_two—1(l)
# @type [Ritournelle::Runtime::StdLib::Float]
n =
  self.add_two—1(Ritournelle::Runtime::StdLib::Float.new(10.0))