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