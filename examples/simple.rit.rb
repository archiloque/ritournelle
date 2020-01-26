i =
  Ritournelle::Runtime::StdLib::Int.new(10)
j =
  Ritournelle::Runtime::StdLib::Int.new(20)
i.plus_int(10)
i.plus_Int(j)
f =
  Ritournelle::Runtime::StdLib::Float.new(10.5)
g =
  j.to_float()

def two()
  return Ritournelle::Runtime::StdLib::Int.new(2)
end


def add_two(number)
  return number.plus_int(2)
end


class Circle
  
  def draw()
  end
  
end
