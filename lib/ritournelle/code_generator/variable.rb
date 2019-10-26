class Ritournelle::CodeGenerator::Variable

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::Variable] variable
  def initialize(variable)
    @result = []
  end
end
