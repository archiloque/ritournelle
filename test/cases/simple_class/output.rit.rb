
class MyClass
  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  
  # @param [Ritournelle::Runtime::StdLib::Float] member1
  # @param [Ritournelle::Runtime::StdLib::Int] member2
  def initialize—0(member1, member2)
    @member1 = member1
    @member2 = member2
  end
  
  
  # @return [Ritournelle::Runtime::StdLib::Int]
  def member2—0()
    return @member2
  end
  
end

# @type [MyClass]
m =
  MyClass.new(0, Ritournelle::Runtime::StdLib::Float.new(1.0), Ritournelle::Runtime::StdLib::Int.new(2))
m.member2—0()