class Ritournelle::IntermediateRepresentation::Assignment

  # @return [String]
  attr_reader :name
  # @return [String|Ritournelle::IntermediateRepresentation::ConstructorCall]
  attr_reader :value

  # @param [String] name
  # @param [String\Ritournelle::IntermediateRepresentation::ConstructorCall] value
  def initialize(name, value)
    @name = name
    @value = value
  end
end
