# @type [Ritournelle::Runtime::StdLib::Integer]
i =
  Ritournelle::Runtime::StdLib::Integer.new(10)
# @type [Ritournelle::Runtime::StdLib::Integer]
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
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is two
def two—0()
  # @type [Ritournelle::Runtime::StdLib::Integer]
  t =
    Ritournelle::Runtime::StdLib::Integer.new(2)
  return t
end
# @type [Ritournelle::Runtime::StdLib::Integer]
l =
  self.two—0()
# @param [Ritournelle::Runtime::StdLib::Integer] number
# @return [Ritournelle::Runtime::StdLib::Integer]
# @note Declared name is add_two
def add_two—1(number)
  return number.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(2))
end
# @param [Ritournelle::Runtime::StdLib::Float] number
# @return [Ritournelle::Runtime::StdLib::Float]
# @note Declared name is add_two
def add_two—2(number)
  return number.plus_Float(Ritournelle::Runtime::StdLib::Float.new(2.0))
end
# @type [Ritournelle::Runtime::StdLib::Integer]
m =
  self.add_two—1(Ritournelle::Runtime::StdLib::Integer.new(10))
# @type [Ritournelle::Runtime::StdLib::Integer]
n =
  self.add_two—1(m)
# @type [Ritournelle::Runtime::StdLib::Float]
o =
  self.add_two—2(Ritournelle::Runtime::StdLib::Float.new(10.0))
# @type [Ritournelle::Runtime::StdLib::Float]
p =
  self.add_two—2(o)