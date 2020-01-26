class Ritournelle::IntermediateRepresentation::Assignment

  # @return [String]
  attr_reader :name

  attr_reader :value

  # @param [String] name
  # @param value
  def initialize(name:, value:)
    @name = name
    @value = value
  end
end
