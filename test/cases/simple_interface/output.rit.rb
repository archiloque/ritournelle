
# @!parse
#   # @abstract
#   module MyInterface
#     # @return [Ritournelle::Runtime::StdLib::Int]
#     # @abstract
#     # @note Declared name is member2_plus2
#     def member2_plus2—0()
#     end
#     
#   end


class MyClass1
  # @!parse
  #   include MyInterface

  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  
  # @param [Ritournelle::Runtime::StdLib::Int] member2
  def initialize—0(member2)
    @member2 = member2
  end
  
  # @return [Ritournelle::Runtime::StdLib::Int]
  # @note Declared name is member2_plus2
  def member2_plus2—0()
    return @member2.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
  end
end


class MyClass2
  # @!parse
  #   include MyInterface

  # @param [Integer] constructor_index
  def initialize(constructor_index, *parameters)
    send("initialize—#{constructor_index}", *parameters)
  end
  
  # @param [Ritournelle::Runtime::StdLib::Int] member2
  def initialize—0(member2)
    @member2 = member2
  end
  
  # @return [Ritournelle::Runtime::StdLib::Int]
  # @note Declared name is member2_plus2
  def member2_plus2—0()
    return @member2.plus_Int(Ritournelle::Runtime::StdLib::Int.new(2))
  end
end

# @type [MyInterface]
m1 =
  MyClass1.new(0, Ritournelle::Runtime::StdLib::Int.new(2))
m1.member2_plus2—0()
# @type [MyInterface]
m2 =
  MyClass2.new(0, Ritournelle::Runtime::StdLib::Int.new(2))
m2.member2_plus2—0()