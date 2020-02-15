
class MyClass
  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  
  # @return [Ritournelle::Runtime::StdLib::Int]
  def member2—0()
    return @member2
  end
  
  
  # @param [Ritournelle::Runtime::StdLib::Int] member3
  # @return [void]
  def member3—1(member3)
    @member3 = member3
  end
  
  
  # @param [Ritournelle::Runtime::StdLib::Float] member1
  # @param [Ritournelle::Runtime::StdLib::Int] member2
  # @param [Ritournelle::Runtime::StdLib::Int] member3
  def initialize—0(member1, member2, member3)
    @member1 = member1
    @member2 = member2
    @member3 = member3
  end
  
  
  # @return [Ritournelle::Runtime::StdLib::Int]
  def member2_plus2—2()
    return @member2.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
  end
  
end

# @type [MyClass]
m =
  MyClass.new(0, Ritournelle::Runtime::StdLib::Float.new(1.0), Ritournelle::Runtime::StdLib::Int.new(2), Ritournelle::Runtime::StdLib::Int.new(2))
m.member2—0()