# @type [Ritournelle::Runtime::StdLib::Boolean]
b =
  Ritournelle::Runtime::StdLib::Boolean.new(true)
# @type [Ritournelle::Runtime::StdLib::Integer]
i =
  Ritournelle::Runtime::StdLib::Integer.new(10)
if b.value
  i =
    i.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(10))
end
if i.more_than_Integer(Ritournelle::Runtime::StdLib::Integer.new(10))
  i =
    i.plus_Integer(Ritournelle::Runtime::StdLib::Integer.new(10))
end