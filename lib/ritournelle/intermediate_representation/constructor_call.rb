class Ritournelle::IntermediateRepresentation::ConstructorCall

  # @return [Ritournelle::IntermediateRepresentation::Class]
  attr_reader :parent

  # @return [Array]
  attr_reader :parameters

  # @param [Ritournelle::IntermediateRepresentation::Class] parent
  # @param [Array] parameters
  def initialize(parent:, parameters:)
    @parent = parent
    @parameters = parameters
  end

end
