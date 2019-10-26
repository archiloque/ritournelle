class Ritournelle::IntermediateRepresentation::Constructor

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Constructor] constructor
  def initialize(constructor)
    @constructor = constructor
  end

end