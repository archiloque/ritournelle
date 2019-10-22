class Ritournelle::IntermediateRepresentation::Assignment

  # @return [String]
  attr_reader :name
  # @return [String]
  attr_reader :value

  # @param [String] name
  # @param [String] value
  def initialize(name, value)
    @name = name
    @value = value
  end
end
