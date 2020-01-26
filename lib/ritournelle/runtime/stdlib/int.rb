class Ritournelle::Runtime::StdLib::Int

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # @param [Ritournelle::Runtime::StdLib::Int] other_int
  # @return [Ritournelle::Runtime::StdLib::Int]
  def plus_Int(other_int)
    Ritournelle::Runtime::StdLib::Int.new(@value + other_int.value)
  end

  # @return [Ritournelle::Runtime::StdLib::Float]
  def to_float()
    Ritournelle::Runtime::StdLib::Float.new(@value.to_f)
  end

end