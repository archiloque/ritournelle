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