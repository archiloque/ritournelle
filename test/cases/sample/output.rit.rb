# @type [Ritournelle::Runtime::StdLib::Int]
i =
  Ritournelle::Runtime::StdLib::Int.new(10)
# @type [Ritournelle::Runtime::StdLib::Int]
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

# @return [Ritournelle::Runtime::StdLib::Int]
def two—0()
  # @type [Ritournelle::Runtime::StdLib::Int]
  t =
    Ritournelle::Runtime::StdLib::Int.new(2)
  return Ritournelle::Runtime::StdLib::Int.new(2)
end

# @type [Ritournelle::Runtime::StdLib::Int]
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

# @type [Ritournelle::Runtime::StdLib::Int]
m =
  self.add_two—1(Ritournelle::Runtime::StdLib::Int.new(10))
# @type [Ritournelle::Runtime::StdLib::Int]
n =
  self.add_two—1(m)
# @type [Ritournelle::Runtime::StdLib::Float]
o =
  self.add_two—2(Ritournelle::Runtime::StdLib::Float.new(10.0))
# @type [Ritournelle::Runtime::StdLib::Float]
p =
  self.add_two—2(o)