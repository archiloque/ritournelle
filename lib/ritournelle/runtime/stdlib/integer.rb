class Ritournelle::Runtime::StdLib::Integer

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # @param [Ritournelle::Runtime::StdLib::Integer] other_Integer
  # @return [Ritournelle::Runtime::StdLib::Integer]
  def plus_Integer(other_Integer)
    Ritournelle::Runtime::StdLib::Integer.new(@value + other_Integer.value)
  end

  # @return [Ritournelle::Runtime::StdLib::Float]
  def to_float()
    Ritournelle::Runtime::StdLib::Float.new(@value.to_f)
  end

  # @param [Ritournelle::Runtime::StdLib::Integer] other_Integer
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def equal_to_Integer(other_Integer)
    Ritournelle::Runtime::StdLib::Boolean.new(@value == other_Integer.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Integer] other_Integer
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def less_than_Integer(other_Integer)
    Ritournelle::Runtime::StdLib::Boolean.new(@value < other_Integer.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Integer] other_Integer
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def less_than_or_equal_to_Integer(other_Integer)
    Ritournelle::Runtime::StdLib::Boolean.new(@value <= other_Integer.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Integer] other_Integer
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def more_than_Integer(other_Integer)
    Ritournelle::Runtime::StdLib::Boolean.new(@value > other_Integer.value)
  end

  # @param [Ritournelle::Runtime::StdLib::Integer] other_Integer
  # @return [Ritournelle::Runtime::StdLib::Bool]
  def more_than_or_equal_to_Integer(other_Integer)
    Ritournelle::Runtime::StdLib::Boolean.new(@value >= other_Integer.value)
  end
  
  # :nocov:
  def to_s
    "Integereger #{@value}"
  end
  # :nocov:

end