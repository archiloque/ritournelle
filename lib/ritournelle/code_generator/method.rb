class Ritournelle::IntermediateRepresentation::Method

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Method] method
  def initialize(method)
    @method = method
  end

end