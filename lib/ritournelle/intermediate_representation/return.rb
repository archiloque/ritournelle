class Ritournelle::IntermediateRepresentation::Return

  # @return [Ritournelle::IntermediateRepresentation::Method]
  attr_reader :parent

  attr_reader :value

  # @param [Ritournelle::IntermediateRepresentation::Method] parent
  # @param [Object] value
  def initialize(parent:, value:)
    @parent = parent
    @value = value
  end
end
