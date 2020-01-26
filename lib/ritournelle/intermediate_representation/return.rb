class Ritournelle::IntermediateRepresentation::Return

  attr_reader :value

  # @param value
  def initialize(value:)
    @value = value
  end
end
