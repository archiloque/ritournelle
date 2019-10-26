class Ritournelle::IntermediateRepresentation::Class

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Class] clazz
  def initialize(clazz)
    @clazz = clazz
  end

end