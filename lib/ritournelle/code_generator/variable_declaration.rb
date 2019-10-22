class Ritournelle::CodeGenerator::VariableDeclaration

  # @return [Array<String>]
  attr_reader :result

  # @param [Ritournelle::IntermediateRepresentation::VariableDeclaration] variable_declaration
  def initialize(variable_declaration)
    @result = []
  end
end
