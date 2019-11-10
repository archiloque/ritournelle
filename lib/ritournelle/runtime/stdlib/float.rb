class Ritournelle::Runtime::StdLib::Float

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # @param [Ritournelle::StdLib::Float] other_float
  # @return [Ritournelle::StdLib::Float]
  def plus_Float(other_float)
    Ritournelle::Runtime::StdLib::Float.new(@value + other_float.value)
  end

  # @param [Floateger] other_float
  # @return [Ritournelle::StdLib::Float]
  def plus_float(other_float)
    Ritournelle::Runtime::StdLib::Float.new(@value + other_float)
  end

end