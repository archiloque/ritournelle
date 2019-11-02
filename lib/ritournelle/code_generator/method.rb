class Ritournelle::CodeGenerator::Method

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Method] method
  # @param [Ritournelle::CodeGenerator::Context] context
  def initialize(method, context)
    @result = []
    raise
  end

end