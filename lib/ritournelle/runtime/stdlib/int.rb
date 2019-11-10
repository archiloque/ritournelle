class Ritournelle::Runtime::StdLib::Int

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # @param [Ritournelle::StdLib::Int] other_int
  # @return [Ritournelle::StdLib::Int]
  def plus_Int(other_int)
    Ritournelle::Runtime::StdLib::Int.new(@value + other_int.value)
  end

  # @param [Integer] other_int
  # @return [Ritournelle::StdLib::Int]
  def plus_int(other_int)
    Ritournelle::Runtime::StdLib::Int.new(@value + other_int)
  end

  # @return [Ritournelle::StdLib::Float]
  def to_float()
    Ritournelle::Runtime::StdLib::Float.new(@value.to_f)
  end

end