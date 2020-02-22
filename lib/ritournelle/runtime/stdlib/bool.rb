class Ritournelle::Runtime::StdLib::Bool

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # :nocov:
  def to_s
    "Boolean #{@value}"
  end
  # :nocov:

end