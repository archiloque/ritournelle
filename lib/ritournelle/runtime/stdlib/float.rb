class Ritournelle::Runtime::StdLib::Float

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Float]
  def plus_Float(other_float)
    Ritournelle::Runtime::StdLib::Float.new(@value + other_float.value)
  end

end