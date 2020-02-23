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

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Float]
  def minus_Float(other_float)
    Ritournelle::Runtime::StdLib::Float.new(@value - other_float.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def equal_to_Float(other_float)
    Ritournelle::Runtime::StdLib::Boolean.new(@value == other_float.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def less_than_Float(other_float)
    Ritournelle::Runtime::StdLib::Boolean.new(@value < other_float.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def less_than_or_equal_to_Float(other_float)
    Ritournelle::Runtime::StdLib::Boolean.new(@value <= other_float.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def more_than_Float(other_float)
    Ritournelle::Runtime::StdLib::Boolean.new(@value > other_float.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Float] other_float
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def more_than_or_equal_to_Float(other_float)
    Ritournelle::Runtime::StdLib::Boolean.new(@value >= other_float.value)
  end

  # :nocov:
  def to_s
    "Float #{@value}"
  end
  # :nocov:

end